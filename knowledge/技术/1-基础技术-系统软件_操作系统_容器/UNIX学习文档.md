# UNIX学习文档



问：Open Source和Free Software有何区别？ 
答：Open Source是Free Software的市场化行销手段，它对Free Software的支持，更倾向于注重实际效果而不是意识形态方面的宣扬。通俗地讲，就是说Open Source已经成为一种“认证商标”，可被用于那些符合定义的软件。 
问：我的网卡不能在我的Linux系统下正常工作，该怎么办？ 
答：使用ifconfig来进行配置。如果运行ifconfig，将会给出所有已经安装了的网卡。如果没有显示可用的网卡，那么很有可能是以下原因之一：1. 网卡没有被Linux检测到；2. 没有与之相应的内核模块；3. 该模块没有被加载；4\. Linux系统不支持你的网卡。就现在来说，出现问题4的可能性很小，一般来说都是问题2和3，也可能是1。 
解决办法是：首先知道所使用的是什么硬件，可以使用如下命令来查看：less/proc/pci/（在此假设所使用的是PCI卡）。在显示的列表中找到“Ethernet Controller”，记下厂商和型号。然后使用modprobe尝试加载正确的模块，比如modprobe 3c509。如果出现错误，说明该模块不存在。这时候你应该找到正确的模块并且重新编译。如果显示说该设备不存在，那也是因为没有正确的模块。找到正确的模块，并且编译之，问题即可解决。 
问：如果不开放源代码是不是更有助于防止黑客攻击？ 
答：回答是否定的。很显然，通过隐藏来达到安全的目的是行不通的。原因在于那些破坏安全的人往往更有激情、更有耐心。无论源码是开放的还是封闭的，他们总会发现漏洞。这样的例子可以说是比比皆是。 
此外，认为封闭源码更安全的观点，事实上犯了三个严重的错误： 
1． 他们创造了一种错误的安全感，即让人们不知道有错误存在，从而认为系统是安全的； 
2． 他们以为人们不会去发现漏洞并且修复这些漏洞； 
3． 对于封闭源代码的系统，当一个漏洞被披露时, 想分发可信赖的补丁是很困难的； 
实际上，开放源码的操作系统和应用程序通常比他们所对应的封闭对手要安全得多。这样的例子举不胜举。 
问：请问自由软件（Free Software）、专有软件（Proprietary Software）、免费软件（Freeware）、共享软件（Shareware）、商业软件（Commercial Software）这些概念之间有何异同之处？ 
答：“自由软件”是指允许任何人使用、拷贝、修改、分发（免费或者收取少量费用）的软件。尤其是这种软件的源代码必须是可得到的。从某种意义上说，“没有源代码，就称不上是自由软件。”
“专有软件”不是自由及非自由软件，对它的使用、传播或修改是禁止的，可能需要时你必须申请许可，或者它限制你不能充分自由地使用它。 
对于“免费软件”则没有一个清晰的定义，但是它通常指那些允许分发但不允许修改的软件包，也就是说不会随软件一起提供源代码。这些软件包不是自由软件，因此不要把“Free Software”和“Freeware”这两个概念混淆。 
“共享软件”允许用户分发该软件，但是任何人想继续使用它就需要支付许可费。共享软件不是自由软件。因为首先大多数共享软件不提供源代码，因此，你不可能修改程序。此外，共享软件不允许在不支付许可费的情况下进行拷贝和分发，即使你是出于非盈利性的目的。 
“商业软件”由商业公司开发，通过收取使用费而赢利。请注意“商业”和“专有”不是一回事！大多数商业软件是“专有”的，但也有商业自由软件，也有非商业、非自由的软件。 
问：源代码开放和Linux有什么关系？ 
答：Linux是一个源代码开放的操作系统，而且到现在为止是最成功的源代码开放的平台。但不只是Linux才是源代码开放的软件，还有许多成功的软件也是源代码开放的，比如Apache等。 
问：我一般使用vi编辑文件。在进行粘贴操作时，每一行前面都会出现一些空格，请问这是什么原因。怎样才能不出现这些空格？ 
答：如果你运行set命令，会发现有一个名为“autoindent(自动缩进)”的属性。你可以在编辑屏幕中使用set noautoindent命令来关闭这一属性。这样，问题就被解决了。 
问：我从网上下载了一个.ISO文件。我想知道里面的具体内容，但是我又没有光刻机，我该怎么办？ 
答：你可以通过以下的步骤来查看该文件的内容： 
1． 使用命令“#mkdir /mnt/iso”来创建挂载点； 
2． 挂载该.iso文件：#mount –t iso9660 –o loop mandrake80-inst.iso /mnt/iso； 
3． 浏览/mnt/iso目录。 
问：我在Linux中打开微软的Windows文件时，发现文件出现了以下情况： 
这是一个^M
用于测试^M
的文件^M
请问我应该如何去掉^M？ 
答：处理这个问题有很多方法，下面列举其中一些： 
1．使用命令：cat filename1 | tr -d “^V^M” > newfile； 
2．使用命令：sed -e “s/^V^M//” filename > outputfilename。需要注意的是在1、2两种方法中，^V和^M指的是Ctrl+V和Ctrl+M。你必须要手工进行输入，而不是粘贴。 
3．在vi中处理：首先使用vi打开文件，然后按ESC键，接着输入命令：%s/^V^M//。 
问：我不想让所有的人都使用“su”命令使其拥有root权限，而只想让一部分人拥有该权限。该怎么办？ 
答：具体方法如下： 
使用命令：vi /etc/pam.d/su打开su配置文件，并在文件的开头加入下面两行： 
auth sufficient /lib/security/pam\_rootok.so debug
auth required /lib/security/pam\_wheel.so group=wheel
加入这两行以后，你的/etc/pam.d/su可能和以下内容相似： 

#%PAM-1.0
auth required /lib/security/pam\_wheel.so group=wheel
account required /lib/security/pam\_pwdb.so
password required /lib/security/pam\_pwdb.so shadow use\_authtok nullok
session optional /lib/security/pam\_xauth.so


好了，这样就只有在wheel组中的成员才可以通过su拥有root权限了。 
问：我想从.rpm文档中解出一些文件，但是我又不想安装它，该怎么办？ 
答：可以使用“rpm2cpio”来从RPM文档中提取文件命令，如下： 

$rpm2cpio<xmms-2.4.rpm >xmms.cpio


注意，在该命令中文件会被解压至当前目录。 
问：我一直搞不清楚Apache是什么意思，能告诉我吗？ 
答：这个问题说来话长。在全球信息网尚未崛起前，在NCSA(National Center for Supercomputing Application)工作的Rob McCool发展出NCSA HTTPd网页服务器。该服务器可以免费下载，并且功能强大，所以很受大家的欢迎。到1995年下半年，它的市场占有率已经是世界第一。Apache服务器的原始核心正是取自于NCSA HTTPd服务器，然后加上各方提供的补丁文件而形成。这样的组合让这套HTTP服务器被大家戏称为“A Patchy Server”，意即“一个修修补补的服务器”。“A Patchy”和“Apache”乃英文谐音，故后来逐渐演变成Apache，沿用至今。 
另NCSA HTTPd目前已经停止发展，其最后版本为1.5.2a。NCSA HTTPd开发小组公开建议大家改用Apache服务器。 
问：我在自己的电脑上安装了Linux，这样我就可以边工作边学习。问题是总有人希望我发送给他们的文档是微软的Word格式。这样，我不得不在两个系统间来回切换，请问有什么更简单的办法吗？ 
答：当然有。事实上，如果仅仅因为这件事，你没有必要安装两个操作系统。你可以在Linux中把文件转换成HTML文件，然后执行命令cp file.html file.doc，然后发送.doc文件。微软的Word会自动将其导入。 
问：在文件名中包含有一些无法输入的特殊字符，我想要更改该文件的名字，该怎么办？ 
答：如果你有一个文件名为“my?file”，在此“？”为你不知该如何输入的字符，那么你可以使用以下方法，首先输入命令： 
ls | grep my？file
确保这样不会有重名文件出现，接下来使用命令： 
mv ls | grep my?file my-file
这样就可达到目的了。 
问：原来我在Windows 2000的IIS上使用ASP进行网站开发，最近我把操作系统换成了Red Hat Linux 7.1，安装的Web服务器是Apache。不知道还能不能继续使用ASP来进行网站开发？ 
答：可以。虽然Apache服务器本身没有内建ASP功能，但是我们可以找到适用的ASP模块。从事这一领域的公司有Chili!Soft公司、[Halcyonsoft.com](http://halcyonsoft.com/)公司、Chamas Enterprise公司。它们所提供的套件及下载地址分别如下： 
Chili!Soft ASP for Linux：[http://www.chilisoft.com](http://www.chilisoft.com/)
Instant ASP：[http://www.halcyonsoft.com](http://www.halcyonsoft.com/)
Apache::ASP：http//:[www.nodeworks.com/asp](http://www.nodeworks.com/asp)
问：我有一本Linux书，上面老提到一个概念：封闭回路。但又没有对其进行详细的解释，不知道它是什么意思？ 
答：我们知道，使用TCP/IP协议的电脑，都会拥有一个IP地址，彼此间相互以IP地址确认对方，传递信息与数据。在有些情况下，我们为了进行某项测试(比如网卡是否正确安装)，或者是没有另外一台电脑作为接收端。这时，我们可利用本机扮演信息的发送端和接收端，这就是所谓的封闭回路。 
封闭回路的IP地址是127.0.0.1，比如你可以在登入系统后执行telnet 127.0.0.1指令，然后再执行w指令观察登入系统的用户： 

#telnet 127.0.0.1
connected to localhost.localdomain(127.0.0.1)
\[eagle@domo eagle\]$w


问：请问SMB和Samba有什么区别和联系？ 
答：SMB是微软于1980年开发的通信协议。通过这一协议，使得网上邻居主机间的文件系统、打印机能够彼此共享。目前类似这种资源共享的通信协议还有NFS、AppleTalk、Netware等。Samba是一个运行于Linux上的、使用SMB通信协议的软件。其功能是实现Windows和Linux之间的资源共享。 
问：怎样在Red Hat 7.0下快速架构一个FTP服务器？ 
答：在Linux下架设FTP服务器是一件很容易的事，并且有很多软件可供选择。在Red Hat 7.0下最简单的办法是使用WU-FTPD来实现。它是目前最具知名度的Linux FTP服务器之一。由于Red Hat Linux 7.0已经内建了WU-FTPD，所以一般来说，在你安装Linux时就已经安装了FTP服务器。如果你不确定自己是否安装了WU-FTPD，可以执行以下命令进行确认： 

＃rpm qa | grep wu-ftpd


如果出现以上结果，表明你已经安装了该软件。否则使用以下命令来安装软件（在此以Red Hat Linux 7.0光盘为例）： 

#mount /dev/cdrom /mnt/cdrom
#rpm ivh wu-ftpd-2.6.1-5.i386.rpm


安装完成后要启动该服务。先建立/etc/xinetd.d/wu-ftpd文件。内容如下所示： 

 service ftp
disable =no
wait=no
server=/usr/sbin/in.ftpd
log\_on\_success+=DURATION USERID
nice=10


有关该文件参数的详细设法请执行man ftpd查询。 
文件建好后重新读取设定文件。执行以下命令： 

#/etc/rc.d/init.d/xinetd reload


确认服务是否启动，可使用命令telnet localhost 21，如果显示ready字样，那么一切OK，服务器就可以使用了。事实上，其它版本的安装设置过程也是大同小异。 
**问：在设置****Linux****服务器时，感觉总是要修改很多文件，有没有一个通用的图形管理的界面？**
答：可以试一试WebMin（[http://www.webmin.com](http://www.webmin.com/)）。这是一个非常不错的软件，它不仅可以让你使用图开界面来设置服务器，还可以让你远程管理Linux主机。即使你使用的是Windows机器，也可以远程管理Linux主机。它的功能非常强大，使用起来也比较简单，可以选择使用中文界面。 
**write error.conversion failed!!**

**Q:** 使用 vi 编辑文件，输入汉字后，保存出现如上的提示，如何解决？
**A:** 是 vi 编辑器的 encoding 的问题，进入 vi 后按 ESC 和 : 键，输入 :set fileencoding=prc 或 :set encoding=prc 就解决了上述问题。因为 vi 编辑器的 encoding 默认是 ascii ，要插入中文需要使用用 prc 编码集。

查看一个目录下文件的数量：find  ./  -type  f  |  wc  -l




    Created at: 2024-03-09T23:12:57+08:00
    Updated at: 2025-09-11T20:12:33+08:00

