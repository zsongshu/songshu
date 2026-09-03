# operationId


@张松树 有个技术相关的需求， 麻烦抽时间搞下吧， 不紧急。 项目背景是这样： admin的审核页面web请求会生成一个随机的operationId， 主要用于审核提交时校验重复请求，以及数仓部分的一些统计工作。 目前这个的相关代码在admin-component里，对项目拆分会产生一些阻力，还有就是在线程上下文里不能方便的拿到当前生成的operationId，有些公共代码需要拿到这个信息，所以需要做如下几个事情：

1\. 调研当前基于operationId的方式和代码设计是否合理
2\. 拆分和抽象现有生成和校验operationId的代码到基础类库
3\. 在web请求上下文保存下当前web请求的operationId
4\. 考虑是否需要定义公共的interceptor，基于白名单自动去set这个operationId，如果需要，实现这个interceptor

jira: <https://jira.corp.kuaishou.com/browse/ADM-7432>  相关核心代码: com.kuaishou.admin.tool.AdminOperationTools



    Created at: 2019-08-21T13:56:34+08:00
    Updated at: 2019-08-21T13:56:54+08:00

