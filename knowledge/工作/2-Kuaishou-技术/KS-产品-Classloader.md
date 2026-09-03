# KS-产品-Classloader

[Ksboot ClassLoader隔离方案](https://docs.corp.kuaishou.com/d/home/fcABd5MIVqK7k2M2MpZFqTxVe#section=h.txjqhqyo1vow)

|     |     |
| --- | --- |
| 背景  | 快手的Java工程采用统一的root pom来管理Jar包版本，该root pom被各条业务线共用，易产生全局风险；<br>且各业务线Jar包存在循环依赖的情况，Jar包版本冲突情况愈发严重，变更时易引发非预期风险；<br>因此亟需提供一种通用的运行时Classloader隔离机制来解决上述问题。 |
| 目标  | 研发包括Classloader运行时隔离和热升级功能在内的通用平台能力，解决由于root pom引入的Jar版本冲突、循环依赖、以及全局变更带来的风险问题，提升快手Springboot开发框架的成熟度，提升业务RD的研发效率。 |
| 双亲委派 | 如果一个类加载器收到了类加载的请求，它首先不会自己去尝试加载这个类，而是把这个请求委托给父类加载器去完成。每个类加载器都是如此，依次向上委托，直到顶层的启动类加载器（Bootstrap ClassLoader）。如果父类加载器无法完成这个请求（即它没有找到对应的类），子加载器才会尝试自己去加载。 |
| 类加载 | 类加载器会首先查找Jar包中的清单文件（MANIFEST.MF），该文件可能包含类索引信息 |
| 类加载器体系结构 | * 启动类加载器（Bootstrap ClassLoader）：负责加载Java核心库，如rt.jar。<br>* 扩展类加载器（Extension ClassLoader）：负责加载Java扩展目录中的类库，如jre/lib/ext。<br>* 应用程序类加载器（Application ClassLoader）：负责加载应用程序的类路径（classpath）上的类库。 |
| Classloader需要解决的问题 |  |
|  |  |
|  |  |





|     |     |     |
| --- | --- | --- |
|  | sofa-ark | ks-ark |
| ClassLoader情况 | 各个sdk拥有独立的ClassLoader与classpath<br>（产出物变大，有大量重复的jar） | infra内各sdk共用ClassLoader与classpath<br>（jar共享，产出物小） |
| 打包步骤 | 自定义maven打包插件，打包成Fat Jar；<br>打破双亲委派，类加载委托给Fat Jar对应的ClassLoader加载 |  |
| 包加载 | * BootstrapClassLoader<br>* ExtensionClassLoader<br>* ApplicationClassLoader<br>* ContainClassLoader（加载sofa-ark类库）<br>	* PluginClassLoader（加载infra类）<br>	* BizClassLoader（反射调用main，加载业务类）<br><br><br><br>Biz与Plugin之间是单向委托，即：<br><br>* Biz调用Plugin时，BizClassLoader可以找到委托的PluginClassLoader。<br>* Plugin调用Biz时，PluginClassLoader无法委托BizClassLoader加载。<br>* Plugin与Plugin互相调用时，PluginClassLoader可以互相委托加载。<br><br><br>Q：Plugin反射调用Biz，或者Plugin使用SPI加载Biz实现类时，应该如何做？<br>A：使用Thread.currentThread().getContextClassLoader() 获取的就是BizClassLoader，各个SDK在需要加载Biz类时，自行使用这个CLassLoader加载。<br>Q：为什么Thread.currentThread().getContextClassLoader() 获取的就是BizClassLoader？<br>A：业务main-class是由BizClassLoader加载的，加载前会 Thread.currentThread().setContextClassLoader(bizClassLoader)，由此扩散创建的所有线程的ContextClassLoader默认都是BizClassLoader。 | * BootstrapClassLoader<br>* ExtensionClassLoader<br>* ApplicationClassLoader<br>* ContainClassLoader（加载sofa-ark类库）<br>	* BizClassLoader（反射调用main，加载业务类)<br>	* GroupPluginClassLoader（加载infra类）<br>		* DBPluginClassLoader<br>		* MQPluginClassLoader |
| infra plugin解释 | export：对外导出的类，遇到之后委托PluginClassLoader加载<br>import：引用的外部类，声明只有这部分类才需要委托其他Classloader加载 | BOOT\_LIBS：与未使用Classloader隔离情况，保持一致<br>INFRA\_LIBS：INFRA相关Jar包含的class描述，以及INFRA依赖三方包（与Biz引入lib冲突的部分） |





    Created at: 2024-06-06T11:38:07+08:00
    Updated at: 2024-06-07T09:30:48+08:00

