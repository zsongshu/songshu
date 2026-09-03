# dlopen加载动态连接库

**编译SO文件（带符号表）**

1. **编写源代码和头文件**首先，需要编写库的源代码（如 mylib.c\`\`）和对应的头文件（如mylib.h\`\`），头文件中声明需要对外公开的函数。
	__
	
2. **编译命令**使用 gcc编译，关键参数是 -fPIC（生成位置无关代码）和 -shared（生成共享库）。**添加** **\-g****选项可以包含调试信息**。
	gcc -g -fPIC -shared mylib.c -o [libmylib.so](http://libmylib.so/)
	
	
3. **验证符号表**编译后，可以使用 nm工具查看生成的SO文件是否包含符号信息：
	nm -D [libmylib.so](http://libmylib.so/) | grep my\_function
	如果输出中包含 my\_function，则说明符号表存在。带有符号表的库文件体积会大一些，但便于调试。
	

### **编译SO文件（不带符号表）**

1. **编译并剥离符号表**一种方法是先编译出带调试信息的SO文件，然后使用 strip命令移除符号表。
	gcc -g -fPIC -shared mylib.c -o [libmylib_with_symbols.so](http://libmylib_with_symbols.so/) strip --strip-all [libmylib_with_symbols.so](http://libmylib_with_symbols.so/) -o [libmylib_stripped.so](http://libmylib_stripped.so/)
	使用 nm检查新的SO文件，my\_function符号将不可见。这种方式显著减小了库文件体积，适合生产环境发布。
	
2. **编译时控制符号可见性（推荐）**更精细的方法是**在编译时直接控制符号的导出**。通过 -fvisibility=hidden参数隐藏所有符号，再使用 \_\_attribute\_\_((visibility("default")))显式标记需要导出的函数。
	_// 在mylib.h中，修改函数声明_ #define DLL\_PUBLIC \_\_attribute\_\_((visibility("default"))) DLL\_PUBLIC void my\_function(void);
	编译命令：
	gcc -fPIC -shared -fvisibility=hidden mylib.c -o [libmylib_visibility_controlled.so](http://libmylib_visibility_controlled.so/)
	这种方法既控制了库的大小，也增强了代码的封装性和安全性。
	

### **使用dlopen加载SO文件**

dlopen系列函数允许程序在运行时动态地加载和使用共享库，非常灵活，常用于插件系统。

1. **示例代码**
	#include <stdio.h> #include <dlfcn.h> int main() { void \*handle; void (\*my\_func)(void); char \*error; _// 1. 打开共享库_ handle = dlopen("./libmylib.so", RTLD\_LAZY); if (!handle) { fprintf(stderr, "dlopen error: %s\\n", dlerror()); return 1; } _// 2. 清除之前可能存在的错误_ dlerror(); _// 3. 获取函数地址_ \*(void \*\*) (&my\_func) = dlsym(handle, "my\_function"); error = dlerror(); if (error != NULL) { fprintf(stderr, "dlsym error: %s\\n", error); dlclose(handle); return 1; } _// 4. 调用动态库中的函数_ my\_func(); _// 5. 关闭共享库句柄_ dlclose(handle); return 0; }
	
2. **编译和运行**编译主程序时需要链接 libdl库。
	gcc -o main main.c -ldl ./main
	

### **加载不带符号表的SO文件**

1. **加载逻辑不变**使用 dlopen加载一个**不带符号表**（例如经过 strip处理）的SO文件，**代码逻辑与加载带符号表的库完全一致**。只要需要导出的函数名没有被剥离，dlsym就能正确找到它们。
2. **关键区别与影响**主要的区别在于**调试体验**。如果程序在调用剥离了符号表的库中的函数时发生崩溃，调试器（如gdb）将无法提供详细的函数名和行号信息，给问题定位带来很大困难。因此，通常建议开发阶段使用带符号表的库，发布阶段再使用优化后的版本。

### **核心要点与建议**

下面的表格总结了这四种操作的核心命令和关键点，方便您快速回顾：



|     |     |     |
| --- | --- | --- |
| 操作场景 | 核心命令/代码 | 关键点/目的 |
| **编译SO（带符号表）** | gcc -g -fPIC -shared mylib.c -o [libmylib.so](http://libmylib.so/) | 便于调试，\-g选项生成调试信息。 |
| **编译SO（不带符号表）** | strip --strip-all [libmylib.so](http://libmylib.so/)<br>或编译时使用 -fvisibility=hidden | 减小体积，提升性能，增强安全，常用于生产环境。 |
| **dlopen加载SO** | handle = dlopen("./libmylib.so", RTLD\_LAZY);<br>func\_ptr = dlsym(handle, "function\_name"); | 运行时动态加载，灵活实现插件化架构。 |
| **加载无符号表SO** | 代码逻辑与加载带符号表SO**完全一致**。 | 不影响功能，但崩溃时难以调试。 |



希望这份梳理能帮助您更好地掌握动态链接库的创建和使用。如果您在具体的实现过程中遇到其他问题，欢迎随时提出。


---


当你使用 dlopen加载两个包含冲突符号的共享库（so）时，可能会遇到一些棘手的问题。为了让你快速抓住核心，下表对比了不同场景下的现象和关键解决方法。



|     |     |     |
| --- | --- | --- |
| 场景描述 | 可能出现的问题 | 关键解决方法 |
| **默认情况**（不使用特殊标志） | 后加载库的符号可能覆盖先加载库的符号，导致函数调用错乱，行为不可预测。 | 使用 RTLD\_LOCAL避免符号污染全局空间。 |
| **库内部依赖冲突**（库A的函数funcA()内部调用了同库的helper()，但helper()与外部符号冲突） | 即使通过dlsym正确拿到了funcA的指针，funcA在执行时也可能错误地链接到其他库中的helper实现，导致崩溃或逻辑错误。 | 使用 RTLD\_DEEPBIND标志，或编译时使用 \-Wl,-Bsymbolic链接器选项。 |
| **需要彻底隔离**（冲突非常严重，或需同时加载同一库的不同版本） | 普通的dlopen即使配合RTLD\_DEEPBIND也无法完全隔离，因为仍在同一全局命名空间下。 | 使用 **dlmopen** 函数在独立的命名空间中加载库（更彻底的隔离方案）。 |



### **🔧 解决方案详解**

了解了问题和核心思路后，我们来看看这些方法具体如何操作。

#### **1\. 编译期解决方案（推荐，从根本上预防）**

如果冲突库的代码是你可控或可以重新编译的，这是**最佳且最根本**的解决方式。

* **控制符号可见性**：目的是尽可能减少库暴露出的符号数量，从源头上避免冲突。你可以使用GCC的编译选项 -fvisibility=hidden，使得库中所有符号默认隐藏。然后，使用 \_\_attribute\_\_((visibility("default")))只显式标记那些需要被外部使用的函数。具体操作如下：
	_// 在头文件中定义宏，方便使用_ #define DLL\_PUBLIC \_\_attribute\_\_((visibility("default"))) _// 只在你需要导出的函数上使用这个属性_ DLL\_PUBLIC int my\_public\_function(int a, int b); _// 内部使用的函数不标记，则会被隐藏_ static int internal\_helper\_function(void);
	编译命令：gcc -fPIC -shared -fvisibility=hidden -o [mylib.so](http://mylib.so/) mylib.c
	
* **设置符号绑定优先级**：在编译共享库时，可以给链接器传递 -Wl,-Bsymbolic选项。这个选项会告诉链接器，**优先使用本库内部定义的符号**，而不是全局符号表中的符号。这能有效解决库内部函数调用被劫持的问题。编译命令：gcc -fPIC -shared -Wl,-Bsymbolic -o [mylib.so](http://mylib.so/) mylib.c

#### **2\. 运行期解决方案（使用****dlopen****标志）**

当你无法修改或重新编译冲突的库时，可以通过在运行时给dlopen传递特定的标志来缓解问题。

* **RTLD\_LOCAL**：这是默认标志。它确保被加载库的符号**不会暴露给后续**通过dlopen加载的其他库。这可以防止符号“污染”全局空间，是良好的编程实践。
	void\* handle1 = dlopen("[libconflict1.so](http://libconflict1.so/)", RTLD\_LAZY | RTLD\_LOCAL); void\* handle2 = dlopen("[libconflict2.so](http://libconflict2.so/)", RTLD\_LAZY | RTLD\_LOCAL);
	
* **RTLD\_DEEPBIND**：这个标志是解决上述“库内部依赖冲突”的利器。它指示动态链接器在查找符号时，**优先从当前被加载的库及其依赖库中查找**，之后再在全局符号表中查找。
	void\* handle = dlopen("[libconflict.so](http://libconflict.so/)", RTLD\_LAZY | RTLD\_DEEPBIND);
	**请注意**：RTLD\_DEEPBIND是Linux特有的标志，并非POSIX标准，其可用性取决于你的glibc版本。在复杂依赖场景下使用时需格外小心。
	

#### **3\. 终极隔离方案：****dlmopen**

如果上述方法仍无法解决你的问题（例如，需要同时加载同一个库的两个不同版本），可以考虑使用 dlmopen。这个函数允许你在一个**全新的、独立的链接映射空间（link map）** 中加载共享库，实现了命名空间的彻底隔离。
_// 尝试在新的命名空间中加载库_ void\* handle = dlmopen(LM\_ID\_NEWLM, "[libconflict.so](http://libconflict.so/)", RTLD\_LAZY); if (!handle) { _// 错误处理..._ }
**重要提示**：dlmopen的功能强大，但使用起来也更复杂，对资源的管理要求更高，并且可能存在一些系统限制。它通常是解决符号冲突的最后手段。

### **💎 核心解决思路与建议**

面对符号冲突，下图梳理了从诊断到选择解决方案的决策流程，帮助你快速定位问题并找到合适的解决路径：
flowchart TD A\[遇到符号冲突问题\] --> B\[诊断与分析\] B --> C{冲突库是否可重新编译?} C -- 是 --> D subgraph D \[编译期解决方案（治本）\] D1\[控制符号可见性<br>（-fvisibility=hidden）\] D2\[设置符号绑定优先级<br>（-Wl,-Bsymbolic）\] end C -- 否 --> E subgraph E \[运行期解决方案（治标）\] E1\[使用 RTLD\_LOCAL<br>避免符号污染\] E2\[使用 RTLD\_DEEPBIND<br>优先内部解析\] end D --> F{问题是否解决?} E --> F F -- 是 --> G\[问题解决\] F -- 否 --> H\[考虑终极方案 dlmopen<br>进行命名空间彻底隔离\] H --> G
总而言之，解决符号冲突最有效的方式是**预防**。在开发和发布共享库时，养成良好的习惯：**默认隐藏所有符号，只显式导出必要的API**。这样能从源头上杜绝绝大部分符号冲突的可能性。希望这些解释能帮助你解决遇到的问题。如果你能分享更多关于冲突库的具体信息（比如是你自己开发的还是第三方的），或许我可以给出更具体的建议。



    Created at: 2025-11-28T18:09:51+08:00
    Updated at: 2025-11-28T18:17:36+08:00

