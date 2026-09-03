# Linux内核

几个重要的Linux系统内核文件介绍

 在网络中，不少服务器采用的是Linux系统。为了进一步提高服务器的性能，可能需要根据特定的硬件及需求重新编译Linux内核。编译Linux内核，需要根据规定的步骤进行，编译内核过程中涉及到几个重要的文件。比如对于RedHat Linux，在/boot目录下有一些与Linux内核有关的文件，进入/boot执行：ls �Cl。编译过RedHat Linux内核的人对其中的System.map 、vmlinuz、initrd-2.4.7-10.img印象可能比较深刻，因为编译内核过程中涉及到这些文件的建立等操作。那么这几个文件是怎么产生的？又有什么作用呢？本文对此做些介绍。

 一、vmlinuz

 vmlinuz是可引导的、压缩的内核。“vm”代表“Virtual Memory”。Linux 支持虚拟内存，不像老的操作系统比如DOS有640KB内存的限制。Linux能够使用硬盘空间作为虚拟内存，因此得名“vm”。vmlinuz是可执行的Linux内核，它位于/boot/vmlinuz，它一般是一个软链接。

 vmlinuz的建立有两种方式。一是编译内核时通过“make zImage”创建，然后通过：

 “cp /usr/src/linux-2.4/arch/i386/linux/boot/zImage /boot/vmlinuz”产生。zImage适用于小内核的情况，它的存在是为了向后的兼容性。二是内核编译时通过命令make bzImage创建，然后通过：“cp /usr/src/linux-2.4/arch/i386/linux/boot/bzImage /boot/vmlinuz”产生。bzImage是压缩的内核映像，需要注意，bzImage不是用bzip2压缩的，bzImage中的bz容易引起误解，bz表示“big zImage”。bzImage中的b是“big”意思。

 zImage（vmlinuz）和bzImage（vmlinuz）都是用gzip压缩的。它们不仅是一个压缩文件，而且在这两个文件的开头部分内嵌有gzip解压缩代码。所以你不能用gunzip 或 gzip �Cdc解包vmlinuz。

 内核文件中包含一个微型的gzip用于解压缩内核并引导它。两者的不同之处在于，老的zImage解压缩内核到低端内存（第一个640K），bzImage解压缩内核到高端内存（1M以上）。如果内核比较小，那么可以采用zImage 或bzImage之一，两种方式引导的系统运行时是相同的。大的内核采用bzImage，不能采用zImage。

 vmlinux是未压缩的内核，vmlinuz是vmlinux的压缩文件。

 二、 initrd-x.x.x.img

 initrd是“initial ramdisk”的简写。initrd一般被用来临时的引导硬件到实际内核vmlinuz能够接管并继续引导的状态。比如，使用的是scsi硬盘，而内核vmlinuz中并没有这个scsi硬件的驱动，那么在装入scsi模块之前，内核不能加载根文件系统，但scsi模块存储在根文件系统的/lib/modules下。为了解决这个问题，可以引导一个能够读实际内核的initrd内核并用initrd修正scsi引导问题。initrd-2.4.7-10.img是用gzip压缩的文件，下面来看一看这个文件的内容。

 initrd实现加载一些模块和安装文件系统等。

 initrd映象文件是使用mkinitrd创建的。mkinitrd实用程序能够创建initrd映象文件。这个命令是RedHat专有的。其它Linux发行版或许有相应的命令。这是个很方便的实用程序。具体情况请看帮助：man mkinitrd

 下面的命令创建initrd映象文件：

 三、 System.map
 System.map是一个特定内核的内核符号表。它是你当前运行的内核的System.map的链接。

 内核符号表是怎么创建的呢? System.map是由“nm vmlinux”产生并且不相关的符号被滤出。对于本文中的例子，编译内核时，System.map创建在/usr/src/linux-2.4/System.map。像下面这样：

 nm /boot/vmlinux-2.4.7-10 > System.map

 下面几行来自/usr/src/linux-2.4/Makefile：

 nm vmlinux | grep -v '(compiled)|(.o$)|( \[aUw\] )|(..ng$)|(LASH\[RL\]DI)' | sort > System.map

 然后复制到/boot:

 cp /usr/src/linux/System.map /boot/System.map-2.4.7-10

 在进行程序设计时，会命名一些变量名或函数名之类的符号。Linux内核是一个很复杂的代码块，有许许多多的全局符号。

 Linux内核不使用符号名，而是通过变量或函数的地址来识别变量或函数名。比如不是使用size\_t BytesRead这样的符号，而是像c0343f20这样引用这个变量。

 对于使用计算机的人来说，更喜欢使用那些像size\_t BytesRead这样的名字，而不喜欢像c0343f20这样的名字。内核主要是用c写的，所以编译器/连接器允许我们编码时使用符号名，当内核运行时使用地址。

 然而，在有的情况下，我们需要知道符号的地址，或者需要知道地址对应的符号。这由符号表来完成，符号表是所有符号连同它们的地址的列表。Linux 符号表使用到2个文件：

 /proc/ksyms

 System.map

 /proc/ksyms是一个“proc file”，在内核引导时创建。实际上，它并不真正的是一个文件，它只不过是内核数据的表示，却给人们是一个磁盘文件的假象，这从它的文件大小是0可以看出来。然而，System.map是存在于你的文件系统上的实际文件。当你编译一个新内核时，各个符号名的地址要发生变化，你的老的System.map具有的是错误的符号信息。每次内核编译时产生一个新的System.map，你应当用新的System.map来取代老的System.map。

 虽然内核本身并不真正使用System.map，但其它程序比如klogd， lsof和ps等软件需要一个正确的System.map。如果你使用错误的或没有System.map，klogd的输出将是不可靠的，这对于排除程序故障会带来困难。没有System.map，你可能会面临一些令人烦恼的提示信息。

 另外少数驱动需要System.map来解析符号，没有为你当前运行的特定内核创建的System.map它们就不能正常工作。

 Linux的内核日志守护进程klogd为了执行名称-地址解析，klogd需要使用System.map。System.map应当放在使用它的软件能够找到它的地方。执行：man klogd可知，如果没有将System.map作为一个变量的位置给klogd，那么它将按照下面的顺序，在三个地方查找System.map：

 /boot/System.map

 /System.map

 /usr/src/linux/System.map

 System.map也有版本信息，klogd能够智能地查找正确的映象（map）文件。

Linux内核
Linux是最受欢迎的自由电脑操作系统内核。它是一个用C语言写成，符合POSIX标准的类Unix操作系统。Linux最早是由芬兰黑客 Linus Torvalds为尝试在英特尔x86架构上提供自由免费的类Unix操作系统而开发的。该计划开始于1991年，这里有一份Linus Torvalds当时在Usenet新闻组comp.os.minix所登载的贴子，这份著名的贴子标志着Linux计划的正式开始。

在计划的早期有一些Minix 黑客提供了协助，而今天全球无数程序员正在为该计划无偿提供帮助。

技术上说Linux是一个内核。“内核”指的是一个提供硬件抽象层、磁盘及文件系统控制、多任务等功能的系统软件。一个内核不是一套完整的操作系统。一套基于Linux内核的完整操作系统叫作Linux操作系统，或是GNU/Linux。

目录 \[隐藏\]
1 架构
2 可移植性
3 专利权
4 参见
5 外部资源

\[编辑\]架构
今天Linux是一个一体化内核（monolithic kernel）系统。设备驱动程序可以完全访问硬件。Linux内的设备驱动程序可以方便地以模块化（modularize）的形式设置，并在系统运行期间可直接装载或卸载。

Linux不是微内核（microkernel）架构的事实曾经引起了Linus Torvalds与Andy Tanenbaum之间一场著名的争论。在这里可以看到当时争论的内容。

\[编辑\]可移植性
尽管Linus Torvalds的初衷不是使Linux成为一个可移植的操作系统，今天的Linux却是全球被最广泛移植的操作系统内核。从掌上电脑iPaq到巨型电脑IBM S/390，甚至于微软出品的游戏机XBOX都可以看到Linux内核的踪迹。Linux也是IBM超级计算机Blue Gene的操作系统。

Linux目前可以在以下结构上运行：

Acorn：Archimedes,A5000和RiscPC系列
康柏：Alpha
惠普：PA-RISC
IA64：英特尔Itanium个人电脑
IBM的S/390和AS/400
英特尔80386及之后的兼容产品：80386, 80486和整个奔腾系列；AMD Athlon, Duron, Thunderbird; Cyrix系列。对英特尔8086, 8088, 80186, 80188和80280芯片的支持正在开发中。
Mips
摩托罗拉68020及以上: 新的Amigas, 一些苹果电脑
PowerPC:所有较新的苹果电脑
SPARC和UltraSPARC：升阳微系统的工作站
Hitachi SuperH: SEGA Dreamcast
索尼公司: PlayStation 2
微软公司: Xbox
ARM系列
\[编辑\]专利权
原先Linus Torvalds将Linux置于一个禁止任何商业行为的条例之下，但之后改用GNU通用公共许可证第二版。该协议允许任何人对软件进行修改或发行，包括商业行为，只要其遵守该协议，所有基于Linux的软件也必须以该协议的形式发表，并提供源代码。

Linus Torvalds曾经公开声称将Linux置于GNU通用公共许可证之下是他一生中所做的“最好的决定”。

\[编辑\]参见
Linus Torvalds
Linux操作系统
\[编辑\]外部资源
Linux内核官方下载中心
日渐膨胀的Linux邮件列表内容摘要
取自"<http://wiki.ccw.com.cn/Linux%E5%86%85%E6%A0%B8>"
页面分类: Linux

Linux系统内核结构详解
Linux内核主要由五个子系统组成：进程调度，内存管理，虚拟文件系统，网络接口，进程间通信。

 1.进程调度（SCHED）:控制进程对CPU的访问。当需要选择下一个进程运行时，由调度程序选择最值得运行的进程。可运行进程实际上是仅等待CPU资源的进程，如果某个进程在等待其它资源，则该进程是不可运行进程。Linux使用了比较简单的基于优先级的进程调度算法选择新的进程。

 2.内存管理（MM）允许多个进程安全的共享主内存区域。Linux的内存管理支持虚拟内存，即在计算机中运行的程序，其代码，数据，堆栈的总量可以超过实际内存的大小，操作系统只是把当前使用的程序块保留在内存中，其余的程序块则保留在磁盘中。必要时，操作系统负责在磁盘和内存间交换程序块。内存管理从逻辑上分为硬件无关部分和硬件有关部分。硬件无关部分提供了进程的映射和逻辑内存的对换；硬件相关的部分为内存管理硬件提供了虚拟接口。

 3.虚拟文件系统（VirtualFileSystem,VFS）隐藏了各种硬件的具体细节，为所有的设备提供了统一的接口，VFS提供了多达数十种不同的文件系统。虚拟文件系统可以分为逻辑文件系统和设备驱动程序。逻辑文件系统指Linux所支持的文件系统，如ext2,fat等，设备驱动程序指为每一种硬件控制器所编写的设备驱动程序模块。

 4.网络接口（NET）提供了对各种网络标准的存取和各种网络硬件的支持。网络接口可分为网络协议和网络驱动程序。网络协议部分负责实现每一种可能的网络传输协议。网络设备驱动程序负责与硬件设备通讯，每一种可能的硬件设备都有相应的设备驱动程序。
5.进程间通讯(IPC) 支持进程间各种通信机制。

 处于中心位置的进程调度，所有其它的子系统都依赖它，因为每个子系统都需要挂起或恢复进程。一般情况下，当一个进程等待硬件操作完成时，它被挂起；当操作真正完成时，进程被恢复执行。例如，当一个进程通过网络发送一条消息时，网络接口需要挂起发送进程，直到硬件成功地完成消息的发送，当消息被成功的发送出去以后，网络接口给进程返回一个代码，表示操作的成功或失败。其他子系统以相似的理由依赖于进程调度。

 各个子系统之间的依赖关系如下：

 进程调度与内存管理之间的关系：这两个子系统互相依赖。在多道程序环境下，程序要运行必须为之创建进程，而创建进程的第一件事情，就是将程序和数据装入内存。

 进程间通信与内存管理的关系：进程间通信子系统要依赖内存管理支持共享内存通信机制，这种机制允许两个进程除了拥有自己的私有空间，还可以存取共同的内存区域。

 虚拟文件系统与网络接口之间的关系：虚拟文件系统利用网络接口支持网络文件系统(NFS),也利用内存管理支持RAMDISK设备。

 内存管理与虚拟文件系统之间的关系：内存管理利用虚拟文件系统支持交换，交换进程(swapd)定期由调度程序调度，这也是内存管理依赖于进程调度的唯一原因。当一个进程存取的内存映射被换出时，内存管理向文件系统发出请求，同时，挂起当前正在运行的进程。

 除了这些依赖关系外，内核中的所有子系统还要依赖于一些共同的资源。这些资源包括所有子系统都用到的过程。例如：分配和释放内存空间的过程，打印警告或错误信息的过程，还有系统的调试例程等等。
系统数据结构

 在linux的内核的实现中，有一些数据结构使用频度较高，他们是：

 task\_struct.

 Linux内核利用一个数据结构（task\_struct）代表一个进程，代表进程的数据结构指针形成了一个task数组(Linux中，任务和进程是相同的术语),这种指针数组有时也称为指针向量。这个数组的大小由NR\_TASKS(默认为512)，表明Linux系统中最多能同时运行的进程数目。当建立新进程的时候，Linux为新进程分配一个task\_struct结构，然后将指针保存在task数组中。调度程序一直维护着一个current指针，他指向当前正在运行的进程。

 Mm\_struct

 每个进程的虚拟内存由一个mm\_struct结构来代表，该结构实际上包含了当前执行映像的有关信息，并且包含了一组指向vm\_area\_struct结构的指针，vm\_area\_struct结构描述了虚拟内存的一个区域。

 Inode

 虚拟文件系统(VFS)中的文件、目录等均由对应的索引节点(inode)代表。每个VFS索引节点中的内容由文件系统专属的例程提供。VFS索引节点只存在于内核内存中，实际保存于VFS的索引节点高速缓存中。如果两个进程用相同的进程打开，则可以共享inade的数据结构，这种共享是通过两个进程中数据块指向相同的inode完成。
Linux的具体结构

 所谓具体结构是指系统实现的结构。

 Linux的具体结构类似于抽象结构，这种对应性是因为抽象结构来源于具体结构，我们的划分没有严格依照源代码的目录结构，且和子系统的分组也不完全匹配，但是，它很接近源代码的目录结构。

 尽管前面的讨论的抽象结构显示了各个子系统之间只有很少的依赖关系，但是具体结构的5个子系统之间有高度的依赖关系。我们可以看出，具体结构中的很多依赖关系并没有在抽象结构中出现。

 Linux内核源代码

 目前，较新而又稳定的内核版本是2.0.x和2.2.x，因为版本不同稍有差别，因此如果你想让一个新的驱动程序既支持2.0.x，又支持2.2.x，就需要根据内核版本进行条件编译，要作到这一点，就要支持宏LINUX\_VERSION\_CODE,假如内核的版本用a.b.c来表示，这个宏的值就是216a+28b+c。要用到指定内核版本的值，我们可以用KERNEL\_VERSION宏，我们也可以自己去定义它。

 对内核的修改用补丁文件的方式发布的。Patch实用程序用来用来对内核源文件进行一系列的修改。例如：你有2.2.9的源代码，但想移到2.2.10。就可以获得2.2.10的补丁文件，应用patch来修改2.2.9源文件。例如：
$ cd /usr/src/linux

 $ patch �Cpl < patch-2.2.10

 Linux 内核源代码的结构

 Linux内核源代码位于/usr/src/linux目录下。

 /include子目录包含了建立内核代码时所需的大部分包含文件，这个模块利用其他模块重建内核。

 /init 子目录包含了内核的初始化代码，这是内核工作的开始的起点。

 /arch子目录包含了所有硬件结构特定的内核代码。如：i386,alpha

 /drivers子目录包含了内核中所有的设备驱动程序，如块设备和SCSI设备。

 /fs子目录包含了所有的文件系统的代码。如:ext2,vfat等。

 /net子目录包含了内核的连网代码。

 /mm子目录包含了所有内存管理代码。

 /ipc子目录包含了进程间通信代码。

 /kernel子目录包含了主内核代码。

 从何处开始阅读源代码？

 在Internet,有人制作了源代码导航器，为阅读源代码提供了良好的条件，站点为[lxr.linux.no/source](http://lxr.linux.no/source)。
下面给出阅读源代码的线索:

 系统的启动和初始化：

 在基于Intel的系统上，当loadlin.exe或LILO把内核装入到内存并把控制权传递给内核时，内核开始启动。关于这一部分请看，arch/i386/kernel/head.S,head.S进行特定结构的设置，然后跳转到init/main.c的main()例程。

 内存管理：

 内存管理的代码主要在/mm，但是特定结构的代码在arch/\*/mm。缺页中断处理的代码在/mm/memory.c ,而内存映射和页高速缓存器的代码在/mm/filemap.c 。缓冲器高速缓存是在/mm/buffer.c 中实现，而交换高速缓存是在mm/swap\_state.c和mm/swapfile.c。

 内核：

 内核中，特定结构的代码在arch/\*/kernel,调度程序在kernel/sched.c,fork的代码在kernel/fork.c,内核例程处理程序在include/linux/interrupt.h，task\_struct数据结构在inlucde/linux/sched.h中。

 PCI:

 PCI伪驱动程序在drivers/pci/pci.c,其定义在inclulde/linux/pci.h。每一种结构都有一些特定的PCI BIOS代码，Intel的在arch/alpha/kernel/bios32.c中。

 进程间通信：

 所有的SystemVIPC对象权限都包含在ipc\_perm数据结构中，这可以在include/linux/ipc.h中找到。SystemV消息是在ipc/msg.c中实现。共享内存在ipc/shm.c中实现。信号量在ipc/sem.c中，管道在/ipc/pipe.c中实现。

 中断处理：

 内核的中断处理代码几乎所有的微处理器特有的。中断处理代码在arch/i386/kernel/irq.c中，其定义在include/asm-i386/irq.h中。

    Created at: 2025-09-10T15:41:01+08:00
    Updated at: 2025-11-19T14:36:51+08:00

