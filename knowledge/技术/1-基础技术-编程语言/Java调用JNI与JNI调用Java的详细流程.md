# Java调用JNI与JNI调用Java的详细流程

# Java调用JNI与JNI调用Java的详细流程

|     |     |     |
| --- | --- | --- |
|  | ## Java调用JNI | ## JNI调用Java |
| 详细流程 | 1、Java对象和CPP对象的数据类型转换<br><br>2、上下文切换：执行Java代码和Native代码的是同一个操作系统线程（pthread），但需要进行上下文切换（从Java执行环境切换到Native执行环境），不是线程切换 | 1、非Java线程调用Java方法时需要将pthread AttachCurrentThread到JVM<br><br>2、Java对象和CPP对象的数据类型转换<br><br>3、上下文切换：从Native执行环境切换到Java执行环境（同一个pthread线程）<br><br>4、方法查找：调用GetMethodID等方法查找Java方法 |
| 优化思路 | #### **1\. 数据类型转换（核心损耗）**<br><br>		**损耗根源**：<br>	<br>			**内存复制**：Java对象（如jstring、jarray）与Native类型（如char\*、int\[\]）转换时，JNI **强制深拷贝数据**（即使同一进程）。<br>		<br>			**编码转换**：字符串需在Java UTF-16与C/C++ UTF-8间转换，计算密集型操作。<br>		<br>			**对象拆箱**：传递Integer等包装类需拆箱为jint，再转为C++ int。<br>		<br>		**量化影响**：<br>	<br>			转换1KB数组 ≈ **10-100μs**（取决于硬件）。<br>		<br>			高频调用时，转换开销可占**总耗时的50%以上**。<br>		<br>		**优化方案**：<br>	<br>			使用DirectByteBuffer或Unsafe**直接操作堆外内存**（避免拷贝）。<br>		<br>			传递原始类型（int而非Integer）。<br>		<br>			减少跨语言数据传递频率（批量处理）。<br>		<br><br>#### **2\. 执行环境切换（重要损耗）**<br><br>		**损耗根源**：<br>	<br>			**栈切换**：同一线程内，Java栈帧与Native栈帧切换需保存/恢复寄存器状态。<br>		<br>			**安全检查**：JNI边界触发GC安全点检查、数组越界校验等。<br>		<br>			**线程状态同步**：JVM需更新线程状态（从\_thread\_in\_Java到\_thread\_in\_native）。<br>		<br>		**量化影响**：<br>	<br>			单次切换 ≈ **100-500ns**（看似少，但高频调用时累积显著）。<br>		<br>			每秒10万次调用 → 切换开销 ≈ **10-50ms**（占CPU时间的1%-5%）。<br>		<br>		**优化方案**：<br>	<br>			减少JNI调用次数（合并逻辑）。<br>		<br>			避免在循环中调用JNI方法。 |     |

```
以下是我的理解，看看对不对： Java调用JNI关键性能损耗点： 1、Java对象和CPP对象的数据类型转换 2、上下文切换：执行Java代码和Native代码的是同一个操作系统线程（pthread），但需要进行上下文切换（从Java执行环境切换到Native执行环境），不是线程切换 JNI调用Java 关键性能损耗点： 1、非Java线程调用Java方法时需要将pthread AttachCurrentThread到JVM 2、Java对象和CPP对象的数据类型转换 3、上下文切换：从Native执行环境切换到Java执行环境（同一个pthread线程） 4、方法查找：调用GetMethodID等方法查找Java方法
```

    Created at: 2026-03-25T14:14:07+08:00
    Updated at: 2026-04-16T23:28:41+08:00

