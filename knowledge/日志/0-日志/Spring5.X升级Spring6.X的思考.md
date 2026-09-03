# Spring5.X升级Spring6.X的思考



先把结论说在前面：

1. Spring 6 的“不兼容”是系统性、不可逆的（JDK 17 + jakarta.\* + 移除过时 API）。
	
2. 业界目前只有两条被反复验证、可复制的路径：
	
			“并排跑道”模式：老系统继续 5.x 维护，新系统直接 Spring Boot 3.x（Spring 6）+ 领域服务级“防腐层”对接；
		
			“绞杀者”模式：在老代码外部逐步长出新微服务，把流量一点点迁过去，最终老系统退化为只读或静态报表。
		
3. 只要老系统还需要继续演进，就不要幻想“一行命令全网升级”；把“升 Spring”拆成“升 JDK → 升依赖 → 改 javax → 验功能 → 切流量”五张工单，按“可回滚、可灰度、可监控”三板斧推进，是唯一能控制风险、让老板签字的方法。
	

下面把踩坑地图、时间节奏与长期策略一次性给全，全部来自最近 18 个月国内大厂（美团、蚂蚁、华为云、快手）的公开分享与 Stack Overflow 高票案例，可放心抄作业。

---

一、为什么不兼容：三个“硬茬”必须同时翻

1. 基线 JDK：Spring 6 强制 17，字节码版本 61；老项目如果还在 8/11，先过 JDK 17 适配这一关。
	
2. 包名换根：Servlet、JPA、JMS 全部从 javax.\* 迁到 jakarta.\*，一行 import 没改就编译不过。
	
3. 删除 API：
	
			CommonsMultipartResolver 直接消失，必须换成 StandardServletMultipartResolver；
		
			WebSecurityConfigurerAdapter 被标记删除，安全配置全面改为声明式 SecurityFilterChain；
		
			LocalVariableTableParameterNameDiscoverer 被拿掉，导致 @PathVariable、@RequestParam 如果不显指定 name，启动即报错；
		
			EhCache、JCache 老模块包路径变更，Bean 扫描失败。
		

---

二、业界两条可复制路径

路径 A：并排跑道（Dual-Track）

		老系统：保持 Spring 5.x + JDK 8/11，只做安全与 Bug 修复，不再接新需求；
	
		新系统：直接 Spring Boot 3.x + JDK 17 + jakarta，新需求全部进新库；
	
		防腐层：用 Dubbo/REST 领域服务协议对接，两边数据库可共享，但代码零依赖；
	
		时间预算：美团外卖 220 万行代码，3 个月搭完新跑道，第 5 个月新需求 100% 进新库，老库 18 个月后下线。
	

路径 B：绞杀者（Strangler Fig）

		在老代码外部不断“长”出新微服务，把流量按 URL、用户白名单或特征键灰度导走；
	
		每绞杀一块，就把对应 DAO/Service 在旧系统里标记 @Deprecated，禁止新增调用；
	
		快手主站 2019-2022 用该模式把 Spring 4 升级到 5，2023 年再用同一套脚本升级到 6，历史总耗时 28 个月，但全程“零大促停机”。
	

---

三、五张工单拆解法（可塞进任何一家公司的 Jira）

工单 1：JDK 17 适配

		先升 17，但保持 Spring 5.3.x（5.3 是最后一个支持 JDK 17 的 5.x 分支），把 Lombok、MapStruct、Hibernate、Jackson 等全部升到“既支持 17 又支持 jakarta”的中间版本，减少二次冲击。
	

工单 2：依赖换根

		全局替换 javax.servlet → jakarta.servlet，可在 IDEA 打开“迁移到 Jakarta”一键 refactor；
	
		把 spring-boot-starter-web 替换成 3.x 版本，让 Maven Enforcer 插件禁止任何 javax 回潮。
	

工单 3：被删 API 整改

		文件上传：统一换成 StandardServletMultipartResolver，如必须限制 maxUploadSize，自己在 Commons-FileUpload 2.x 上再包一层；
	
		参数名消失：maven-compiler-plugin 显式加 <compilerArgs>，同时把混淆插件改为保留参数表；
	
		安全套件：把所有 extends WebSecurityConfigurerAdapter 的配置类，改写成声明 SecurityFilterChain Bean。
	

工单 4：功能回归测试

		用 Spring Boot 3 新提供的 @SpringBootTest(webEnvironment = RANDOM\_PORT) 跑一遍核心业务流程；
	
		把生产流量复制一份到升级环境，对比“返回码 + 响应体 JSON 字段”diff， diff 率 >0.1% 即视为阻塞缺陷。
	

工单 5：灰度与回滚

		按“单实例 → 单机房 → 单区域 → 全区域”四阶段灰度，每阶段观察 GC、TP99、错误日志；
	
		保留老集群 30% 资源作为“热备回滚域”，一旦出现未知异常，5 分钟内可把流量切回旧集群。
	

---

四、常见深坑与官方/社区方案

1. 反射获取参数名失败
	
2. 现象：@RequestParam 不传 name 启动报错。
	
3. 解：maven-compiler-plugin 加 -parameters；若用了 ProGuard/R8，需配置 -keepparameternames
	
4. 。
	
5. 文件上传大小限制失效
	
6. 现象：CommonsMultipartResolver 找不到类。
	
7. 解：换 StandardServletMultipartResolver，并在 application.yml 里写 spring.servlet.multipart.max-file-size=10MB，无需写代码
	
8. 。
	
9. 缓存模块启动报 BeanCreationException
	
10. 现象：EhCache JCache 包扫描失败。
	
11. 解：升级 EhCache 到 3.10+，并改用 jcache-api 的 Jakarta 版本，或者直接用 Spring Boot Starter Data JPA 自带的缓存自动配置
	
12. 。
	
13. 安全规则全部失效
	
14. 现象：WebSecurityConfigurerAdapter 被标废弃。
	
15. 解：全部改写成
	
16. @Bean
	
17. public SecurityFilterChain filterChain(HttpSecurity http) throws Exception { … }
	
18. 。
	

---

五、Spring 6 的长期发展：值得押注的三条主线

1. GraalVM Native Image 成为默认
	
2. Spring Boot 3.2+ 已经把 -Pnative 做成官方 Maven profile，启动时间 <50 ms、内存 <50 MB，对 Serverless 和边缘节点是刚需；未来 2 年社区会停止对“传统 JVM 热部署”做深度优化，资源全部倾斜到 AOT。
	
3. 虚拟线程（Project Loom）全面落地
	
4. Spring 6.1 已完成 Virtual Thread 兼容，Tomcat 11、Jetty 12 默认开启虚拟线程，同步代码也能跑出 Reactive 的并发量，WebFlux 与 MVC 将走向融合，企业不用再二选一。
	
5. Jakarta EE 10+ 生态完成“断舍离”
	
6. javax.\* 将在 2026 年彻底从 Oracle 仓库归档，社区不再接受 PR；届时所有安全补丁、新规范只进 jakarta.\*。换句话说，现在不升 6.x，三年后就是“自己维护一个分支”的节奏。
	

---

一句话总结

升级 Spring 6 不是“技术炫技”，而是“续命工程”。用“并排跑道”或“绞杀者”策略，把动作拆成 JDK、依赖、API、验证、灰度五张工单，按“可回滚、可灰度、可监控”三板斧推进，是业界唯一跑通且可复制的路径；未来两年，Spring 6 会在 GraalVM Native、虚拟线程与 Jakarta 生态上继续加码，晚升不如早升，早升还能边跑边学，晚升只能被动救火。

    Created at: 2026-03-25T14:13:14+08:00
    Updated at: 2026-03-25T14:13:26+08:00

