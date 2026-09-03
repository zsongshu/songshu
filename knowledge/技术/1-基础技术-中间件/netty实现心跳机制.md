# netty实现心跳机制

netty对心跳机制提供了机制，实现的关键是**IdleStateHandler**先来看一下他的构造函数

**public** **IdleStateHandler****(**
 **long** readerIdleTime**,** **long** writerIdleTime**,** **long** allIdleTime**,**
 TimeUnit unit**)** **{**
 **this****(****false****,** readerIdleTime**,** writerIdleTime**,** allIdleTime**,** unit**);**
 **}**

实例化一个 IdleStateHandler 需要提供三个参数:

* readerIdleTimeSeconds, 读超时. 即当在指定的时间间隔内没有从 Channel 读取到数据时, 会触发一个 READER\_IDLE 的 IdleStateEvent 事件.
* writerIdleTimeSeconds, 写超时. 即当在指定的时间间隔内没有数据写入到 Channel 时, 会触发一个 WRITER\_IDLE 的 IdleStateEvent 事件.
* allIdleTimeSeconds, 读和写都超时. 即当在指定的时间间隔内没有读并且写操作时, 会触发一个 ALL\_IDLE 的 IdleStateEvent 事件.

### **netty心跳流程**

1\. 客户端成功连接服务端。
2.在客户端中的ChannelPipeline中加入IdleStateHandler，设置写事件触发事件为5s.
3.客户端超过5s未写数据，触发写事件，向服务端发送心跳包，
4.同样，服务端要对心跳包做出响应，其实给客户端最好的回复就是“不回复”，减轻服务端的压力
5.超过三次，1过0s服务端都会收到来自客户端的心跳信息，服务端可以认为客户端挂了，可以close链路。
6.客户端恢复正常，发现链路已断，重新连接服务端。

### **代码实现**

服务端handler:

**package** com.heartbreak.server**;**

**import** [io.netty.channel.ChannelHandlerContext](http://io.netty.channel.ChannelHandlerContext)**;**
**import** [io.netty.channel.SimpleChannelInboundHandler](http://io.netty.channel.SimpleChannelInboundHandler)**;**
**import** [io.netty.handler.timeout.IdleState](http://io.netty.handler.timeout.IdleState)**;**
**import** [io.netty.handler.timeout.IdleStateEvent](http://io.netty.handler.timeout.IdleStateEvent)**;**

**import** java.util.Random**;**

**/**\\**\***\\**\***
\\**\*** @author janti
\\**\*** @date 2018**/**6**/**10 12**:**21
\\**\*/**
**public** **class** **HeartbeatServerHandler** **extends** SimpleChannelInboundHandler**<**String**\>** **{**
 _// 失败计数器：未收到client端发送的ping请求_
 **private** **int** unRecPingTimes **\=** 0**;**

 _// 定义服务端没有收到心跳消息的最大次数_
 **private** **static** **final** **int** MAX\\\_UN\\\_REC\\\_PING\\\_TIMES **\=** 3**;**

 **private** Random random **\=** **new** Random**(**System**.**currentTimeMillis**());**

 @Override
 **protected** **void** **channelRead0****(**ChannelHandlerContext ctx**,** String msg**)** **throws** Exception **{**
 **if** **(**msg**!=****null** **&&** msg**.**equals**(**"Heartbeat"**)){**
 System**.**out**.**println**(**"客户端"**+**ctx**.**channel**().**remoteAddress**()+**"--心跳信息--"**);**
 **}****else** **{**
 System**.**out**.**println**(**"客户端----请求消息----："**+**msg**);**
 String resp \\**\=** "商品的价格是："**+**random**.**nextInt**(**1000**);**
 ctx**.**writeAndFlush**(**resp**);**
 **}**
 **}**

 @Override
 **public** **void** **userEventTriggered****(**ChannelHandlerContext ctx**,** Object evt**)** **throws** Exception **{**
 **if** **(**evt **instanceof** IdleStateEvent**)** **{**
 IdleStateEvent event \\**\=** **(**IdleStateEvent**)** evt**;**
 **if** **(**event**.**state**()==**IdleState**.**READER\\\_IDLE**){**
 System**.**out**.**println**(**"===服务端===(READER\\\_IDLE 读超时)"**);**
 _// 失败计数器次数大于等于3次的时候，关闭链接，等待client重连_
 **if** **(**unRecPingTimes **\>=** MAX\\\_UN\\\_REC\\\_PING\\\_TIMES**)** **{**
 System**.**out**.**println**(**"===服务端===(读超时，关闭chanel)"**);**
 _// 连续超过N次未收到client的ping消息，那么关闭该通道，等待client重连_
 ctx**.**close**();**
 **}** **else** **{**
 _// 失败计数器加1_
 unRecPingTimes**++;**
 **}**
 **}****else** **{**
 **super****.**userEventTriggered**(**ctx**,**evt**);**
 **}**
 **}**
 **}**

 @Override
 **public** **void** **channelActive****(**ChannelHandlerContext ctx**)** **throws** Exception **{**
 **super****.**channelActive**(**ctx**);**
 System**.**out**.**println**(**"一个客户端已连接"**);**
 **}**

 @Override
 **public** **void** **channelInactive****(**ChannelHandlerContext ctx**)** **throws** Exception **{**
 **super****.**channelInactive**(**ctx**);**
 System**.**out**.**println**(**"一个客户端已断开连接"**);**
 **}**
**}**

服务端server：

**package** com.heartbreak.server**;**

**import** [io.netty.bootstrap.ServerBootstrap](http://io.netty.bootstrap.ServerBootstrap)**;**
**import** [io.netty.channel](http://io.netty.channel).\\**\*;**
**import** [io.netty.channel.nio.NioEventLoopGroup](http://io.netty.channel.nio.NioEventLoopGroup)**;**
**import** [io.netty.channel.socket.SocketChannel](http://io.netty.channel.socket.SocketChannel)**;**
**import** [io.netty.channel.socket.nio.NioServerSocketChannel](http://io.netty.channel.socket.nio.NioServerSocketChannel)**;**
**import** [io.netty.handler.codec.string.StringDecoder](http://io.netty.handler.codec.string.StringDecoder)**;**
**import** [io.netty.handler.codec.string.StringEncoder](http://io.netty.handler.codec.string.StringEncoder)**;**
**import** [io.netty.handler.timeout.IdleStateHandler](http://io.netty.handler.timeout.IdleStateHandler)**;**

**import** java.util.concurrent.TimeUnit**;**

**/**\\**\***\\**\***
\\**\*** @author tangj
\\**\*** @date 2018**/**6**/**10 10**:**46
\\**\*/**
**public** **class** **HeartBeatServer** **{**
 **private** **static** **int** port **\=** 9817**;**

 **public** **HeartBeatServer****(****int** port**)** **{**
 **this****.**port **\=** port**;**
 **}**

 ServerBootstrap bootstrap \\**\=** **null****;**
 ChannelFuture f**;**

 _// 检测chanel是否接受过心跳数据时间间隔（单位秒）_
 **private** **static** **final** **int** READ\\\_WAIT\\\_SECONDS **\=** 10**;**

 **public** **static** **void** **main****(**String args\\**\[**\\**\])** **{**
 HeartBeatServer heartBeatServer \\**\=** **new** HeartBeatServer**(**port**);**
 heartBeatServer**.**startServer**();**
 **}**

 **public** **void** **startServer****()** **{**
 EventLoopGroup bossgroup \\**\=** **new** NioEventLoopGroup**();**
 EventLoopGroup workergroup \\**\=** **new** NioEventLoopGroup**();**
 **try** **{**
 bootstrap \\**\=** **new** ServerBootstrap**();**
 bootstrap**.**group**(**bossgroup**,** workergroup**)**
 **.**channel**(**NioServerSocketChannel**.**class**)**
 **.**childHandler**(****new** HeartBeatServerInitializer**());**
 _// 服务器绑定端口监听_
 f **\=** bootstrap**.**bind**(**port**).**sync**();**
 System**.**out**.**println**(**"server start ,port: "**+**port**);**
 _// 监听服务器关闭监听，此方法会阻塞_
 f**.**channel**().**closeFuture**().**sync**();**
 **}** **catch** **(**Exception e**)** **{**
 e**.**printStackTrace**();**
 **}** **finally** **{**
 bossgroup**.**shutdownGracefully**();**
 workergroup**.**shutdownGracefully**();**
 **}**
 **}**


 **private** **class** **HeartBeatServerInitializer** **extends** ChannelInitializer**<**SocketChannel**\>** **{**

 @Override
 **protected** **void** **initChannel****(**SocketChannel ch**)** **throws** Exception **{**
 ChannelPipeline pipeline \\**\=** ch**.**pipeline**();**
 _// 监听读操作,读超时时间为5秒，超过5秒关闭channel;_
 pipeline**.**addLast**(**"ping"**,** **new** IdleStateHandler**(**READ\\\_WAIT\\\_SECONDS**,** 0**,** 0**,** TimeUnit**.**SECONDS**));**
 pipeline**.**addLast**(**"decoder"**,** **new** StringDecoder**());**
 pipeline**.**addLast**(**"encoder"**,** **new** StringEncoder**());**

 pipeline**.**addLast**(**"handler"**,** **new** HeartbeatServerHandler**());**
 **}**
 **}**

**}**

客户端handler

**package** com.heartbreak.client**;**

**import** [io.netty.buffer.ByteBuf](http://io.netty.buffer.ByteBuf)**;**
**import** [io.netty.buffer.Unpooled](http://io.netty.buffer.Unpooled)**;**
**import** [io.netty.channel.ChannelHandlerContext](http://io.netty.channel.ChannelHandlerContext)**;**
**import** [io.netty.channel.EventLoop](http://io.netty.channel.EventLoop)**;**
**import** [io.netty.channel.SimpleChannelInboundHandler](http://io.netty.channel.SimpleChannelInboundHandler)**;**
**import** [io.netty.handler.timeout.IdleState](http://io.netty.handler.timeout.IdleState)**;**
**import** [io.netty.handler.timeout.IdleStateEvent](http://io.netty.handler.timeout.IdleStateEvent)**;**
**import** [io.netty.util.CharsetUtil](http://io.netty.util.CharsetUtil)**;**
**import** [io.netty.util.ReferenceCountUtil](http://io.netty.util.ReferenceCountUtil)**;**

**import** java.text.SimpleDateFormat**;**
**import** java.util.Date**;**
**import** java.util.concurrent.TimeUnit**;**

**/**\\**\***\\**\***
\\**\*** @author tangj
\\**\*** @date 2018**/**6**/**11 22**:**55
\\**\*/**
**public** **class** **HeartBeatClientHandler** **extends** SimpleChannelInboundHandler**<**String**\>{**
 **private** HeartBeatClient client**;**

 **private** SimpleDateFormat format **\=** **new** SimpleDateFormat**(**"yyyy-MM-dd HH:mm:dd"**);**

 **private** **static** **final** ByteBuf HEARTBEAT\\\_SEQUENCE **\=** Unpooled**.**unreleasableBuffer**(**Unpooled**.**copiedBuffer**(**"Heartbeat"**,**
 CharsetUtil**.**UTF\\\_8**));**

 **public** **HeartBeatClientHandler****(**HeartBeatClient client**)** **{**
 **this****.**client **\=** client**;**
 **}**
 @Override
 **protected** **void** **channelRead0****(**ChannelHandlerContext ctx**,** String msg**)** **throws** Exception **{**
 System**.**out**.**println**(**"收到服务端回复："**+**msg**);**
 **if** **(**msg**.**equals**(**"Heartbeat"**))** **{**
 ctx**.**write**(**"has read message from server"**);**
 ctx**.**flush**();**
 **}**
 ReferenceCountUtil**.**release**(**msg**);**
 **}**

 @Override
 **public** **void** **userEventTriggered****(**ChannelHandlerContext ctx**,** Object evt**)** **throws** Exception **{**
 **if** **(**evt **instanceof** IdleStateEvent**)** **{**
 IdleState state \\**\=** **((**IdleStateEvent**)** evt**).**state**();**
 **if** **(**state **\==** IdleState**.**WRITER\\\_IDLE**)** **{**
 ctx**.**writeAndFlush**(**HEARTBEAT\\\_SEQUENCE**.**duplicate**());**
 **}**
 **}** **else** **{**
 **super****.**userEventTriggered**(**ctx**,** evt**);**
 **}**
 **}**

 @Override
 **public** **void** **channelInactive****(**ChannelHandlerContext ctx**)** **throws** Exception **{**
 **super****.**channelInactive**(**ctx**);**
 System**.**err**.**println**(**"客户端与服务端断开连接,断开的时间为："**+**format**.**format**(****new** Date**()));**
 _// 定时线程 断线重连_
 **final** EventLoop eventLoop **\=** ctx**.**channel**().**eventLoop**();**
 eventLoop**.**schedule**(****new** Runnable**()** **{**
 @Override
 **public** **void** **run****()** **{**
 client**.**doConncet**();**
 **}**
 **},** 10**,** TimeUnit**.**SECONDS**);**
 **}**


**}**

客户端启动:

**package** com.heartbreak.client**;**

**import** [io.netty.bootstrap.Bootstrap](http://io.netty.bootstrap.Bootstrap)**;**
**import** [io.netty.buffer.ByteBuf](http://io.netty.buffer.ByteBuf)**;**
**import** [io.netty.channel](http://io.netty.channel).\\**\*;**
**import** [io.netty.channel.nio.NioEventLoopGroup](http://io.netty.channel.nio.NioEventLoopGroup)**;**
**import** [io.netty.channel.socket.SocketChannel](http://io.netty.channel.socket.SocketChannel)**;**
**import** [io.netty.channel.socket.nio.NioSocketChannel](http://io.netty.channel.socket.nio.NioSocketChannel)**;**
**import** [io.netty.handler.codec.string.StringDecoder](http://io.netty.handler.codec.string.StringDecoder)**;**
**import** [io.netty.handler.codec.string.StringEncoder](http://io.netty.handler.codec.string.StringEncoder)**;**
**import** [io.netty.handler.timeout.IdleStateHandler](http://io.netty.handler.timeout.IdleStateHandler)**;**

**import** java.io.BufferedReader**;**
**import** java.io.InputStreamReader**;**
**import** java.util.Random**;**
**import** java.util.concurrent.TimeUnit**;**

**/**\\**\***\\**\***
\\**\*** @author tangj
\\**\*** @date 2018**/**6**/**10 16**:**18
\\**\*/**
**public** **class** **HeartBeatClient** **{**

 **private** Random random **\=** **new** Random**();**
 **public** Channel channel**;**
 **public** Bootstrap bootstrap**;**

 **protected** String host **\=** "127.0.0.1"**;**
 **protected** **int** port **\=** 9817**;**

 **public** **static** **void** **main****(**String args\\**\[**\\**\])** **throws** Exception **{**
 HeartBeatClient client \\**\=** **new** HeartBeatClient**();**
 client**.**run**();**
 client**.**sendData**();**

 **}**

 **public** **void** **run****()** **throws** Exception **{**
 EventLoopGroup group \\**\=** **new** NioEventLoopGroup**();**
 **try** **{**
 bootstrap \\**\=** **new** Bootstrap**();**
 bootstrap**.**group**(**group**)**
 **.**channel**(**NioSocketChannel**.**class**)**
 **.**handler**(****new** SimpleClientInitializer**(**HeartBeatClient**.**this**));**
 doConncet**();**
 **}** **catch** **(**Exception e**)** **{**
 e**.**printStackTrace**();**
 **}**
 **}**

 **/**\\**\***\\**\***
 \\**\*** 发送数据
 \\**\*** @throws Exception
 \\**\*/**
 **public** **void** **sendData****()** **throws** Exception **{**
 BufferedReader in \\**\=** **new** BufferedReader**(****new** InputStreamReader**(**System**.**in**));**
 **while** **(****true****){**
 String cmd \\**\=** in**.**readLine**();**
 **switch** **(**cmd**){**
 **case** "close" **:**
 channel**.**close**();**
 **break****;**
 **default****:**
 channel**.**writeAndFlush**(**in**.**readLine**());**
 **break****;**
 **}**
 **}**
 **}**

 **/**\\**\***\\**\***
 \\**\*** 连接服务端
 \\**\*/**
 **public** **void** **doConncet****()** **{**
 **if** **(**channel **!=** **null** **&&** channel**.**isActive**())** **{**
 **return****;**
 **}**
 ChannelFuture channelFuture \\**\=** bootstrap**.**connect**(**host**,** port**);**
 channelFuture**.**addListener**(****new** ChannelFutureListener**()** **{**
 @Override
 **public** **void** **operationComplete****(**ChannelFuture futureListener**)** **throws** Exception **{**
 **if** **(**channelFuture**.**isSuccess**())** **{**
 channel \\**\=** futureListener**.**channel**();**
 System**.**out**.**println**(**"connect server successfully"**);**
 **}** **else** **{**
 System**.**out**.**println**(**"Failed to connect to server, try connect after 10s"**);**
 futureListener**.**channel**().**eventLoop**().**schedule**(****new** Runnable**()** **{**
 @Override
 **public** **void** **run****()** **{**
 doConncet**();**
 **}**
 **},** 10**,** TimeUnit**.**SECONDS**);**
 **}**
 **}**
 **});**

 **}**


 **private** **class** **SimpleClientInitializer** **extends** ChannelInitializer**<**SocketChannel**\>** **{**

 **private** HeartBeatClient client**;**

 **public** **SimpleClientInitializer****(**HeartBeatClient client**)** **{**
 **this****.**client **\=** client**;**
 **}**

 @Override
 **protected** **void** **initChannel****(**SocketChannel socketChannel**)** **throws** Exception **{**
 ChannelPipeline pipeline \\**\=** socketChannel**.**pipeline**();**
 pipeline**.**addLast**(****new** IdleStateHandler**(**0**,** 5**,** 0**));**
 pipeline**.**addLast**(**"encoder"**,** **new** StringEncoder**());**
 pipeline**.**addLast**(**"decoder"**,** **new** StringDecoder**());**
 pipeline**.**addLast**(**"handler"**,** **new** HeartBeatClientHandler**(**client**));**
 **}**
 **}**


**}**

运行结果：
1.客户端长时间未发送心跳包，服务端关闭连接

server start **,**port**:** 9817
一个客户端已连接
\\**\===**服务端**\===(**READER\\\_IDLE 读超时**)**
\\**\===**服务端**\===(**READER\\\_IDLE 读超时**)**
\\**\===**服务端**\===(**READER\\\_IDLE 读超时**)**
\\**\===**服务端**\===(**READER\\\_IDLE 读超时**)**
\\**\===**服务端**\===(**读超时，关闭chanel**)**
一个客户端已断开连接

2.客户端发送心跳包，服务端和客户端保持心跳信息

一个客户端已连接
客户端**/**127**.**0**.**0**.**1**:**55436**\--**心跳信息**\--**
客户端**/**127**.**0**.**0**.**1**:**55436**\--**心跳信息**\--**
客户端**/**127**.**0**.**0**.**1**:**55436**\--**心跳信息**\--**
客户端**/**127**.**0**.**0**.**1**:**55436**\--**心跳信息**\--**

3.服务单宕机，断开连接，客户端进行重连

客户端与服务端断开连接**,**断开的时间为：2018**\-**06**\-**12 23**:**47**:**12
Failed to connect to server**,** **try** connect after 10s
Failed to connect to server**,** **try** connect after 10s
Failed to connect to server**,** **try** connect after 10s
connect server successfully

### **代码地址：**

[https://github.com/jantent/LearnTCP](https://link.zhihu.com/?target=https%3A//github.com/JayTange/LearnTCP)

> 作者：Janti
> 连接：[https://www.](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/superfj/p/9153776.html)[cnblogs.com/superfj/p/9](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/superfj/p/9153776.html)[153776.html](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/superfj/p/9153776.html)



    Created at: 2023-03-14T21:13:07+08:00
    Updated at: 2023-03-14T21:14:27+08:00

