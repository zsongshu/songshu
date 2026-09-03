# Java文件IO操作教程之DirectIO的意义

**前言**
在前文《文件IO操作的一些最佳实践》中，我介绍了一些 Java 中常见的文件操作的接口，并且就 PageCache 和 DIrect IO 进行了探讨，最近我自己封装了一个 Direct IO 的库，趁着这个机会，本文重点谈谈 Java 中 Direct IO 的意义，以及简单介绍下我自己的轮子。
**Java 中的 Direct IO**
如果你阅读过我之前的文章，应该已经了解 Java 中常用的文件操作接口为：FileChannel，并且没有直接操作 Direct IO 的接口。这也就意味着 Java 无法绕开 PageCache 直接对存储设备进行读写，但对于使用 Java 语言来编写的数据库，消息队列等产品而言，的确存在绕开 PageCache 的需求：

* PageCache 属于操作系统层面的概念，用户层面很难干预，User BufferCache 显然比 Kernel PageCache 要可控
* 现代操作系统会使用尽可能多的空闲内存来充当 PageCache，当操作系统回收 PageCache 内存的速度低于应用写缓存的速度时，会影响磁盘写入的速率，直接表现为写入 RT 增大，这被称之为“毛刺现象”

PageCache 可能会好心办坏事，采用 Direct IO + 自定义内存管理机制会使得产品更加的可控，高性能。
**Direct IO 的限制**
在 Java 中使用 Direct IO 最终需要调用到 c 语言的 pwrite 接口，并设置 O\_DIRECT flag，使用 O\_DIRECT 存在不少限制

* 操作系统限制：Linux 操作系统在 2.4.10 及以后的版本中支持 O\_DIRECT flag，老版本会忽略该 Flag；Mac OS 也有类似于 O\_DIRECT 的机制
* 用于传递数据的缓冲区，其内存边界必须对齐为 blockSize 的整数倍
* 用于传递数据的缓冲区，其传递数据的大小必须是 blockSize 的整数倍。
* 数据传输的开始点，即文件和设备的偏移量，必须是 blockSize 的整数倍

> 查看系统 blockSize 大小的方式：stat /boot/|grep “IO Block”
> ubuntu@VM-30-130-ubuntu:~$ stat /boot/|grep “IO Block”
> 
> Size: 4096 Blocks: 8 IO Block: 4096 directory
> 通常为 4kb

**Java 使用 Direct IO**
**项目地址**
<https://github.com/lexburner/kdio>
**引入依赖**

1. <dependency>
2. <groupId>moe.cnkirito.kdio</groupId>
3. <artifactId>kdio-core</artifactId>
4. <version>1.0.0</version>
5. </dependency>

**注意事项**

1. // file path should be specific since the different file path determine whether your system support direct io
2. public static DirectIOLib directIOLib \= DirectIOLib.getLibForPath("/");
3. // you should always write into your disk the Integer-Multiple of block size through direct io.
4. // in most system, the block size is 4kb
5. private static final int BLOCK\_SIZE \= 4 \* 1024;

Direct IO 写

1. private static void write() throws IOException {
2. if (DirectIOLib.binit) {
3. ByteBuffer byteBuffer \= DirectIOUtils.allocateForDirectIO(directIOLib, 4 \* BLOCK\_SIZE);
4. for (int i \= 0; i < BLOCK\_SIZE; i++) {
5. byteBuffer.putInt(i);
6. }
7. byteBuffer.flip();
8. DirectRandomAccessFile directRandomAccessFile \= new DirectRandomAccessFile(new File("./database.data"), "rw");
9. directRandomAccessFile.write(byteBuffer, 0);
10. } else {
11. throw new RuntimeException("your system do not support direct io");
12. }
13. }

Direct IO 读

1. public static void read() throws IOException {
2. if (DirectIOLib.binit) {
3. ByteBuffer byteBuffer \= DirectIOUtils.allocateForDirectIO(directIOLib, 4 \* BLOCK\_SIZE);
4. DirectRandomAccessFile directRandomAccessFile \= new DirectRandomAccessFile(new File("./database.data"), "rw");
5. directRandomAccessFile.read(byteBuffer, 0);
6. byteBuffer.flip();
7. for (int i \= 0; i < BLOCK\_SIZE; i++) {
8. System.out.print(byteBuffer.getInt() + " ");
9. }
10. } else {
11. throw new RuntimeException("your system do not support direct io");
12. }
13. }

**主要 API**

* DirectIOLib.java 提供 Native 的 pwrite 和 pread
* DirectIOUtils.java 提供工具类方法，比如分配 Block 对齐的 ByteBuffer
* DirectChannel/DirectChannelImpl.java 提供对 fd 的 Direct 包装，提供类似 FileChannel 的读写 API。
* DirectRandomAccessFile.java 通过 DIO 的方式打开文件，并暴露 IO 接口。

**总结**
这个简单的 Direct IO 框架参考了[smacke/jaydio](https://github.com/smacke/jaydio)，这个库自己搞了一套 Buffer 接口跟 JDK 的类库不兼容，且读写实现里面加了一块 Buffer 用于缓存内容至 Block 对齐有点破坏 Direct IO 的语义。同时，感谢尘央同学的指导，这个小轮子的代码量并不多，初始代码引用自他的一个小 demo（已获得本人授权）。为什么需要这么一个库？主要是考虑后续会出现像「中间件性能挑战赛」和「PolarDB性能挑战赛」这样的比赛，Java 本身的 API 可能不足以发挥其优势，如果有一个库可以屏蔽掉 Java 和 CPP 选手的差距，岂不是美哉？我也将这个库发到了中央仓库，方便大家在自己的代码中引用。
后续会视需求，会这个小小的轮子增加注入 fadvise，mmap 等系统调用的映射，也欢迎对文件操作感兴趣的同学一起参与进来，pull request & issue are welcome！
好了，以上就是这篇文章的全部内容了，希望本文的内容对大家的学习或者工作具有一定的参考学习价值，如果有疑问大家可以留言交流，谢谢大家对我们的支持。

    Created at: 2026-02-28T18:15:11+08:00
    Updated at: 2026-03-13T10:30:59+08:00

