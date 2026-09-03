# epool 详细说明

**epoll** 是 Linux 内核为处理大量文件描述符而设计的高效 I/O 多路复用机制。它有三个核心的系统调用：epoll\_create, epoll\_ctl, 和 epoll\_wait。

---

### **1\.** **epoll\_create****/** **epoll\_create1****\- 创建 epoll 实例**

**作用**：创建一个新的 epoll 实例，并返回一个指向该实例的文件描述符。
#include <sys/epoll.h> 
int epoll\_create(int size); 
int epoll\_create1(int flags);
**参数含义**：

* **size** (在 epoll\_create中)：在 Linux 2.6.8 之后，这个参数被忽略，但必须大于 0。它原本表示期望监控的文件描述符数量，内核会根据实际使用情况动态调整。
* **flags** (在 epoll\_create1中)：
	* 如果为 0，行为同 epoll\_create
	* EPOLL\_CLOEXEC：设置 close-on-exec 标志，这样在执行 exec系列函数时，该文件描述符会被自动关闭，避免被子进程继承。

**返回值**：

* 成功：返回一个文件描述符（epoll 实例的句柄）
* 失败：返回 -1，并设置 errno

**现代用法**：推荐使用 epoll\_create1(0)。

---

### **2\.** **epoll\_ctl****\- 管理 epoll 实例中的文件描述符**

**作用**：向 epoll 实例中添加、修改或删除要监控的文件描述符。
int epoll\_ctl(int epfd, int op, int fd, struct epoll\_event \*event);
**参数含义**：

1. **epfd**：epoll\_create返回的 epoll 实例文件描述符
2. **op**：操作类型，指定要执行的动作：
	* **EPOLL\_CTL\_ADD**：将新的文件描述符 fd添加到 epoll 实例中
	* **EPOLL\_CTL\_MOD**：修改已注册的文件描述符 fd的监控事件
	* **EPOLL\_CTL\_DEL**：从 epoll 实例中删除文件描述符 fd
3. **fd**：要操作的目标文件描述符（如 socket 描述符）
4. **event**：指向 epoll\_event结构体的指针，描述要监控的事件


**struct epoll\_event****结构体**：
typedef union epoll\_data { 
void \*ptr; int fd; uint32\_t u32; uint64\_t u64; 
} epoll\_data\_t; 

struct epoll\_event { 
uint32\_t events; _/\* 要监控的 epoll 事件（位掩码） \*/_ epoll\_data\_t data; _/\* 用户数据，当事件发生时会被返回 \*/_ };

**events****字段的常见值（位掩码，可用** **|****组合）**：

* **EPOLLIN**：文件描述符可读
* **EPOLLOUT**：文件描述符可写
* **EPOLLERR**：文件描述符发生错误（会自动监控，无需显式设置）
* **EPOLLHUP**：文件描述符被挂起（如对端关闭连接）
* **EPOLLET**：设置为边沿触发（ET）模式，默认为水平触发（LT）
* **EPOLLONESHOT**：事件只通知一次，触发后需重新用 EPOLL\_CTL\_MOD启用

**data****字段**：用户自定义数据，当事件发生时，这个数据会原样返回，用于识别是哪个文件描述符的事件。

---

### **3\.** **epoll\_wait****\- 等待事件发生**

**作用**：等待在 epoll 实例中注册的文件描述符上的事件发生。
int epoll\_wait(int epfd, struct epoll\_event \*events, int maxevents, int timeout);
**参数含义**：

1. **epfd**：epoll 实例的文件描述符
2. **events**：指向 epoll\_event结构体数组的指针，用于存放就绪的事件
3. **maxevents**：events数组的大小，表示一次最多能返回多少个事件
4. **timeout**：超时时间（毫秒）
	* **\-1**：阻塞等待，直到有事件发生
	* **0**：立即返回，即使没有事件
	* **\> 0**：等待指定的毫秒数

**返回值**：

* **\> 0**：返回就绪的文件描述符数量
* **\= 0**：超时时间内没有事件发生
* **\-1**：出错，并设置 errno

---

### **完整使用示例**

#include <sys/epoll.h> 
#include <unistd.h> 
#include <stdio.h> 
#define MAX\_EVENTS 10 
int main() { 
int epoll\_fd, nfds; 
struct epoll\_event ev, events\[MAX\_EVENTS\]; 

_// 1. 创建 epoll 实例_ 
epoll\_fd = epoll\_create1(0); 
if (epoll\_fd == -1) { 
perror("epoll\_create1"); return 1; 
} 

_// 2. 添加要监控的文件描述符（这里以标准输入为例）_ 
ev.events = EPOLLIN; _// 监控可读事件_ 
ev.data.fd = STDIN\_FILENO; _// 用户数据设置为文件描述符本身_ 
if (epoll\_ctl(epoll\_fd, EPOLL\_CTL\_ADD, STDIN\_FILENO, &ev) == -1) {
 perror("epoll\_ctl: STDIN\_FILENO"); return 1; 
} 

_// 3. 进入事件循环_ 
while (1) {
 nfds = epoll\_wait(epoll\_fd, events, MAX\_EVENTS, -1); _// 阻塞等待_ 
if (nfds == -1) { perror("epoll\_wait"); break; } 

_// 4. 处理所有就绪的事件_ 
for (int i = 0; i < nfds; i++) { 
if (events\[i\].data.fd == STDIN\_FILENO) { 
if (events\[i\].events & EPOLLIN) { 
printf("标准输入有数据可读\\n"); _// 读取并处理数据..._ _// 如果是 ET 模式，需要循环读取直到 EAGAIN_ 
} 
} 
} 
} 
close(epoll\_fd); return 0; 
}

### **关键设计要点**

1. **高效的数据结构**：epoll 使用红黑树存储监控的 fd，使用就绪链表存储就绪事件，使得添加、删除、查找操作都很高效。
2. **内核态与用户态共享**：就绪列表由内核维护，epoll\_wait直接从中拷贝数据，避免了像 select/poll 那样全量扫描。
3. **事件驱动**：只有真正活跃的连接才会触发回调，适合连接数多但活跃度不高的场景。



    Created at: 2025-11-14T16:57:24+08:00
    Updated at: 2025-11-14T17:04:02+08:00

