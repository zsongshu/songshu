# java文件IO操作之DirectIO

目前Java无法绕过PageCache直接在存储设备上进行读写，但在某些场景将操作系统的Cache旁路掉又很有必要，比如大多数数据库产品都使用Direct I/O进行数据读写并有自己的内存管理机制。

PageCache缓存机制对于上层业务来说不够透明，很难去干预和配置缓存策略，对于MQ来讲，PageCache带来了以下弊端：


1. 在进行消息读写时会因为页错误，内存回收，脏页回写，PageCache的TreeLock等带来很大的毛刺。
2. 磁盘的容量远远大于内存的容量，在读取冷数据时候，又需要重建缓存，内存的换入换出频繁，效率低。甚至在大量冷数据堆积的情况下，整个系统都会被拖慢，影响正常的业务。

所以通过Direct I/O的方式进行存储的读写，自建缓存，自定义内存管理策略非常有必要，具体就不赘述，本文主要是记录Java如何使用Direct I/O。

## 
<https://www.atatech.org/articles/102747%230>

## 

## **限制**

使用Direct IO有不少的限制条件，比如：

1. 操作系统版本限制：Linux操作系统在2.4.10及以后的版本中支持O\_DIRECT flag，老版本会忽略该Flag。Mac OS也有类似于O\_DIRECT的机制，不做讨论。
2. 读写大小：每一次IO读取或者写入的内容大小必须为block size的倍数。
3. Buffer限制：读IO的目的buffer和写IO的源buffer必须是block对齐的，比如在传入给pwrite的buf的地址必须是block size的倍数。

## **Java使用Direct IO**

### 
<https://www.atatech.org/articles/102747%232>
**打开文件**

Java使用Direct I/O的步骤比较繁琐，最好借助JNA来完成。
首先需要检测内核版本信息是否支持Flag：O\_DIRECT。
如果支持，变可以通过open调用以O\_DIRECT的方式打开一个文件：

//定义native方法
private static native int open(String pathname, int flags, int mode);

//以read+write和direct的方式打开一个文件句柄
int fd = open(pathname, O\_RDWR | O\_DIRECT, 00644);

Copy

### 
<https://www.atatech.org/articles/102747%233>
**创建Buffer**
**在对文件进行DIO的读写时，我们通过pwrite和pread来完成：**

**private static native NativeLong pwrite(int fd, Pointer buf, NativeLong count, NativeLong offset);**
**private static native NativeLong pread(int fd, Pointer buf, NativeLong count, NativeLong offset);**

**Copy**

**pwrite和pread需要Native的Buffer，在上文中说到Buffer的地址需要Block对齐，但Java无法直接分配Block对齐的DirectBuffer（可以通过sun.nio.PageAlignDirectMemory做到页对齐，但Page跟Block可能并不一致）。所以我们需要通过posix\_memalign来分配一块Block对齐的DirectBuffer：**

**public static native int posix\_memalign(PointerByReference memptr, NativeLong alignment, NativeLong size);**
**Copy**

**第二个参数传入Block size，第三个参数传入Buffer大小即可，可通过pathconf指定路径来获取FS的Block Size。**
**分配好Buffer时便有了一个对齐的Pointer可直接使用pwrite和pread。**

### 
<https://www.atatech.org/articles/102747%234>
**封装**
**目前有的fd和一些Pointer对于Java来说太Native了，为了与JDK的库做兼容，需要进行一些简单的封装。**
**将posix\_memalign分配的内存封装为Direct的ByteBuffer，需要通过反射调用JavaNioAccess#newDirectByteBuffer：**

**public static ByteBuffer wrapPointer(long ptr, int len) {**
**try {**
**ByteBuffer buf = (ByteBuffer) NEW\_DIRECT\_BUF\_MTD.invoke(JAVA\_NIO\_ACCESS\_OBJ, ptr, len, null);**
**assert buf.isDirect();**
**return buf;**
**} catch (ReflectiveOperationException e) {**
**}**
**}**

**Copy**

**JAVA\_NIO\_ACCESS\_OBJ 和 NEW\_DIRECT\_BUF\_MTD需要通过反射来获取**

**//获取JAVA\_NIO\_ACCESS\_OBJ**
**String pkgName = "sun" // Java9+使用"jdk.internal"**
**Class<?> cls = Class.forName(pkgName + ".misc.SharedSecrets");**
**Method mth = cls.getMethod("getJavaNioAccess");**
**Object JAVA\_NIO\_ACCESS\_OBJ = mth.invoke(null);**

**//获取NEW\_DIRECT\_BUF\_MTD**
**Class<?> cls = JAVA\_NIO\_ACCESS\_OBJ.getClass();**
**Method NEW\_DIRECT\_BUF\_MTD = cls.getMethod("newDirectByteBuffer", long.class, int.class, Object.class);**

**Copy**

**使用示例：**

**PointerByReference pointerToPointer = new PointerByReference();**
**// align memory for use with O\_DIRECT**
**posix\_memalign(pointerToPointer, blockSize, new NativeLong(capacity));**
**ByteBuffer byteBuffer = wrapPointer(Pointer.nativeValue(pointerToPointer.getValue()), capacity);**

**Copy**

**Block对齐的ByteBuffer便可以跟JDK的各类API进行兼容了。**
**pwrite的方法可以显得Java范一点了：**

**public int pwrite(int fd, ByteBuffer buf, long offset) {**
**final long address = ((DirectBuffer) buf).address();**
**Pointer pointer = new Pointer(address);**
**int n = pwrite(fd, pointer.share(start), new NativeLong(buf.limit() - buf.position()), new NativeLong(offset)).intValue();**
**if (n < 0) {**
**//Handle IO Error**
**}**
**return n;**
**}**

**Copy**

**再将FD封装到DirectRandomAccessFile中就大功告成了，详细代码见：**<http://gitlab.alibaba-inc.com/xinyuzhou.zxy/java-direct> **:**

1. **DirectIOLib.java提供Native的pwrite和pried**
2. **DirectIOUtils.java提供工具类方法，比如分配Block对齐的ByteBuffer**
3. **DirectChannel/DirectChannelImpl.java提供对fd的Direct包装，提供类FileChannel的读写API。**
4. **DirectRandomAccessFile.java通过DIO的方式打开文件，并暴露IO接口。**

**这个简单的DIO框架参考了**[smacke/jaydio](https://github.com/smacke/jaydio)**，改造过后适配MQ的需求，smacke/jaydio这个库自己搞了一套Buffer接口跟JDK的类库不兼容，且读写实现里面加了一块Buffer用于缓存内容至Block对齐有点破坏DIO的语义。**

### 
<https://www.atatech.org/articles/102747%235>
**示例代码**

读：

File file = new File("./test.log");
DirectRandomAccessFile directRandomAccessFile = new DirectRandomAccessFile(file, "rw");

DirectIOLib directIOLib = DirectIOLib.getLibForPath(file.toString());

ByteBuffer dst = DirectIOUtils.allocateForDirectIO(directIOLib, 4096);
//从0读取4k的内容
directRandomAccessFile.read(dst, 0);

Copy

写：

File file = new File("./test.log");
DirectRandomAccessFile directRandomAccessFile = new DirectRandomAccessFile(file, "rw");

DirectIOLib directIOLib = DirectIOLib.getLibForPath(file.toString());

ByteBuffer src = DirectIOUtils.allocateForDirectIO(directIOLib, 4096);
src.putInt(123);
//写入4k的buffer
directRandomAccessFile.write(src, 0);

Copy

测试一下：
[![dcd99dcea80218e41426c1a7429c66f7.png](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/dcd99dcea80218e41426c1a7429c66f7.png)](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/dcd99dcea80218e41426c1a7429c66f7.png)
可以看到200M/s的写入，但内存使用并没有变化，PageCache被旁路掉了。




import com.sun.jna.\*;

public class HelloWorld {

public static native double cos(double x);
public static native double sin(double x);

static {
Native.register(Platform.C\_LIBRARY\_NAME);
}

public static void main(String\[\] args) {
System.out.println("cos(0)=" + cos(0));
System.out.println("sin(0)=" + sin(0));
}
}




    Created at: 2019-08-01T10:40:16+08:00
    Updated at: 2025-04-09T14:40:55+08:00

