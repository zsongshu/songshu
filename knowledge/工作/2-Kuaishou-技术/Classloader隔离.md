# Classloader隔离

Classloader隔离

|     |     |
| --- | --- |
| 收益  | 阿里的Pandora是一个基于隔离技术的轻量级容器，主要解决了应用与中间件之间以及中间件与中间件之间的依赖冲突问题 105。使用Pandora的收益包括：<br><br>1. 依赖隔离：Pandora通过不同的ClassLoader实现类隔离，包括pandoraClassLoader、ModuleClassLoader和bizClassLoader，从而避免版本冲突 105。<br>	<br>2. 部署隔离：Pandora实现了部署与应用的分离，可以独立升级中间件版本，提高应用的稳定性和中间件的管理效率 105。<br>	<br>3. 中间件平滑升级：应用服务器会优先加载Pandora的类，因此只需升级Pandora中的插件即可，无需修改应用中的pom.xml 106。<br>	<br>4. 统一管理：Pandora统一管理中间件的启动、初始化以及资源回收等操作，简化了运维管理 106。<br>	<br>5. 提高开发效率：Pandora Boot结合了Pandora和Spring Boot，允许在IDE中直接启动Pandora环境，提升了开发和调试的效率 105106。<br>	<br>6. 与Spring Boot集成：Pandora Boot与Spring Boot AutoConfigure深度集成，方便用户使用Spring Boot社区带来的便利 106。<br>	<br>7. 多环境支持：Pandora支持在不同环境下使用，包括本地开发环境和部署在如阿里云EDAS这样的平台上 108。<br>	<br>8. 服务治理：Pandora集成了服务发现、配置推送和调用链跟踪等中间件功能插件，有助于全方位运维管理和服务监控 108。<br>	<br>9. Serverless部署：Pandora Boot适用于部署在Serverless应用引擎上，为需要使用HSF的Spring Boot用户提供便利 109。<br>	<br><br>通过这些功能，Pandora和Pandora Boot为应用提供了一个稳定、高效和易于管理的运行环境。 |
|  |  |
|  | 收益：<br><br><br><br>Q3目标：发布一个线上服务<br><br><br><br>		有两个classloader，infra-classloader，biz-classloader<br>	<br>		infra需要把发布出去的class导出，后续遇到导出类，有infra-classloader加载；其余类由biz-classloader加载 |
|  | 需要解决的几个问题<br><br>1. infra、biz使用各自的Clasloader加载<br>	<br>	1. 打破双亲委派机制<br>		<br>	2. 声明export类和import类<br>		<br>		1. export：对外声明，遇到export列表中的类时，需要委托infra Classloader来加载<br>			<br>		2. import：对外声明，遇到import列表中的类时，需要委托外部类加载器来加载<br>			<br>2. infra、biz使用不同版本的包<br>	<br>	1. infra视角：标识了自己需要使用的Jar包列表及版本<br>		<br>	2. Biz视角：识别出biz和infra冲突的jar，并将冲突的jar单独下载一番，和infra.jar合并打包，供infra运行时使用<br>		<br>3. infra导出的SPI依赖了第三方Jar（第三方Jar被不同的Classloader加载了）<br>	<br>	1. 需要将这部分class显式 import |
|  |  |
|  |  |
|  |  |
|  |     |



    Created at: 2026-03-25T14:47:16+08:00
    Updated at: 2026-03-25T14:47:22+08:00

