# CPU的各种状态


Cpu(s):  0.4%us,  0.2%sy,  0.0%ni, 99.4%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st


* us: 用户进程占用 CPU 时间百分比（user space）。
* sy: 系统进程占用 CPU 时间百分比（system space）。
* ni: 改变过优先级的进程占用 CPU 时间百分比（niceness，一般为负数）。
* id: CPU 空闲时间占用百分比（idle）。
* wa: 等待 I/O 操作完成占用 CPU 时间百分比（I/O wait）。
* hi: 硬中断（hardware interrupt）占用 CPU 时间百分比。
* si: 软中断（software interrupt）占用 CPU 时间百分比。
* st: 虚拟机偷取时间占用 CPU 时间百分比（virtualization steal time）。

这些参数通常会显示在操作系统的系统监视器和命令行界面中，可以帮助用户了解系统资源（尤其是 CPU）的占用情况。例如，在上述数据中，CPU几乎处于空闲状态（99.4%id），用户程序占用了少量 CPU 时间（0.4%us），系统程序占用了更少的 CPU 时间（0.2%sy），没有程序在等待 I/O 操作完成。

    Created at: 2023-04-10T17:25:39+08:00
    Updated at: 2023-04-10T17:26:45+08:00

