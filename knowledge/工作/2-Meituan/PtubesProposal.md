# PtubesProposal

## Abstract

Ptubes是一款基于PITR（Point In Time Recovery）方式实现的数据库灾备产品，可用于将整个数据库还原到特定的时间点，帮助使用者提升数据库的可靠性和安全性。

Ptubes提供了数据库变更事件安全备份、高效分发等功能，可广泛应用于数据备份、数据恢复、数据回放、事件驱动、数据库多活等场景。

Ptubes is a database disaster recovery product based on PITR (Point In Time Recovery), which can be used to restore the database to a specific point in time and help users improve the reliability and security of the database.

Ptubes provides functions such as secure backup and efficient distribution of database change events(binary log, binlog), which can be widely used in scenarios such as data backup, data recovery, data playback, event-driven, and database Multi-Site High Availability.

## Proposal

## Ptubes

Ptubes以关系型数据库（例如Mysql、Postgresql）的在线变更日志作为数据源，实时获取增量变更日志，并将其存储到本地或远程云盘。

Ptubes采用了灵活、可线性扩展的分布式调度框架，以及通过高效的数据分发协议，严格遵循原始数据的事务一致性，把数据秒级备份到多种存储介质，也可以使用日志把数据库修复到指定的时间点。

Ptubes是美团实现数据容灾的基础组件，每天处理了近万亿行数据。我们希望加入ASF之后，可以推动Ptubes朝着更多样化、更国际化的方向发展，构建一个完善的数据灾备领域的开源社区。

Ptubes uses the binlog of relational databases (such as Mysql, Postgresql) as the data source, obtains the incremental change log in real time, and stores it in the local or remote cloud drive.

Ptubes adopts a flexible and linearly scalable distributed scheduling framework, and through an efficient data distribution protocol, strictly follows the transaction consistency of the original data, backs up the data to a variety of storage media in seconds, and can also use the log to restore the database to specified point in time.

Ptubes is the basic components for Meituan to achieve data disaster recovery, processing nearly one trillion rows of data every day. We hope that after joining ASF, we can push Ptubes towards a more diversified and international direction and build a perfect open source community in data disaster recovery.

## Background

Ptubes 从2015年开始在美团立项开发，从那时起一直在美团的生产环境中使用，覆盖了上万个Mysql集群，为各业务团队提供了可靠、高效的数据库变更日志的存储和分发服务，同时也是美团异地多活工程的核心基础组件，支持了外卖等多个业务系统的异地容灾架构升级。

如今，在美团，Ptubes 集群每天处理接近万亿个事件。为2万多个核心应用提供服务。我们相信 Ptubes 可以造福更多的人，所以我们愿意通过 ASF 分享它，并通过 The Apache Way 开始开发一个开发者和用户社区。

Ptubes has been developed in Meituan since 2015, and has been used in the production environment of Meituan since then, covering tens of thousands of Mysql clusters, providing various business teams with reliable and efficient storage and distribution of database change logs Service is also the core basic component of Meituan's remote multi-activity project, which supports the remote disaster recovery architecture upgrade of multiple business systems such as food delivery.

Today, at Meituan, the Ptubes cluster processes close to a trillion events per day. Serves more than 20,000 core applications. We believe that Ptubes can benefit more people, so we are willing to share it through ASF and start developing a community of developers and users through The Apache Way.

## Rationale

通过Ptubes，使用者可以简单、灵活的打造属于自己的数据库灾备产品，解决在研发、生产过程中遇到的各种数据容灾问题。我们预计它会被赋予许多新特性，Ptubes也会持续迭代和增强产品的基础能力，便于大家接受和使用。

Through Ptubes, users can simply and flexibly create their own database disaster recovery products to solve various data disaster recovery problems encountered in the process of R&D and production. We expect that it will be endowed with many new features, and Ptubes will continue to iterate and enhance the basic capabilities of the product for everyone to accept and use.

## Initial Goals

虽然 Ptubes 的大部分主要开发已经完成，但仍有几个功能点需要进一步增强。我们希望在 Apache 孵化阶段关注的一些领域包括：

		支持更多样的数据库引擎，扩展产品的应用范围
	

		丰富对于数据库日志的计算能力，便于用户适配个性化的数据模型
	
		提供独立的负载均衡服务，便于用户更轻量的把Ptubes运行起来
	

While most of the major development of Ptubes has been completed, there are still several functional points that need further enhancements. Some of the areas we hope to focus on during the Apache incubation phase include:

		Support more diverse database engines to expand the application scope of the product
	
		Enriching the computing power for database logs, making it easy for users to adapt to personalized data models
	
		Provide independent load balancing service to facilitate the lightweight operation of Ptubes
	

## Current Status

### Meritocracy

在过去的几年，Ptubes一直作为内部产品为美团的业务系统提供服务，近期在美团基础技术部门的大力支持下决定开源，目的是期望把在美团经历过充分验证的产品能力输出到社区，以帮助更多的开发者以低成本获得可靠的数据容灾服务，并且随着越来越多的开发者参与其中，产品形态也可以更加丰富和成熟。我们将按照 Apache 的精英管理方式组织社区角色，为产品贡献者和社区参与者提供及时详尽的技术支持，并与那些对项目做出重大贡献的人合作，鼓励他们成为提交者。

In the past few years, Ptubes has been providing services for Meituan's business system as an internal product. Recently, with the strong support of Meituan's basic technology department, it has decided to open source. The purpose is to export products that have been fully verified in Meituan to the community and help more developers obtain reliable data disaster recovery services at low cost, and as more and more developers participate, the product form can be more abundant and mature. We will organize community roles according to Apache's meritocracy, provide timely and detailed technical support to product contributors and community participants, and work with those who have made significant contributions to the project to encourage them to become committers.

### Community

Ptubes 目前由美团的工程师开发，被各业务系统高度依赖和使用。现在我们使用GitHub 进行代码托管和社区交流，我们希望通过邀请所有通过使用 Apache Way 做出重大贡献并表现出色的人来扩大贡献者。 Ptubes项目已经准备好接受来自各行各业的开发者参与进来，为了进一步实现这一目标，该项目目前利用 GitHub 项目功能以及通过 Google Groups 提供的公共邮件列表。

Ptubes are currently developed by Meituan engineers and are highly relied upon and used by various business systems. Now we use GitHub for code hosting and community communication, We would like to invite everyone who has made significant contributions and performed well using the Apache Way to expand contributors. The Ptubes project is ready to accept participation from developers from all walks of life, and to further this goal, the project currently utilizes the GitHub project functionality as well as a public mailing list via Google Groups.

### Core Developers:

目前，Ptubes的核心开发人员均来自美团数据库团队，团队成员均具备多年数据库和中间件研发经验。李凯是美团数据库负责人，也是 OceanBase、TiDB的核心贡献者，在分布式数据库领域具有很高的影响力。张松树是Ptubes 负责人，也是Seata 项目的发起者之一，拥有丰富的开源软件经验。吕妃、杨阳、王善策、王辉、孔浩，从事分布式中间件设计与研发多年，对软件工程有着极大的热情。

At present, the core developers of Ptubes are all from the Meituan database team, and the team members have many years of experience in database and middleware research and development. Kai Li is the head of the Meituan database and a core contributor to OceanBase and TiDB. He has a high influence in the field of distributed databases. Songshu Zhang is the director of Ptubes and one of the initiators of the Seata project. He has rich experience in open source software. Fei Lv, Yang Yang, Shance Wang, Hui Wang, and Hao Kong have been engaged in the design and development of distributed middleware for many years, and have great enthusiasm for software engineering.

### Alignment

ASF 是托管 Ptubes 项目的自然选择，因为它鼓励社区驱动的开源项目的目标符合我们对 Ptubes 的愿景。 ASF 也是Apache RocketMQ、Apache ShardingSphere等项目的所在地。我们计划与它们集成并协同工作，以实现互惠互利。

ASF is a natural choice for hosting the Ptubes project, as it encourages community-driven open source projects whose goals are in line with our vision for Ptubes. ASF is also home to projects such as Apache RocketMQ, Apache ShardingSphere. We plan to integrate and work with them for mutual benefit.

## Known Risks

### Project Name

我们已经检查并认为该名称是合适的，并且该项目具有继续使用其当前名称的合法许可。通过 Google 搜索未找到使用此名称的其他项目。

We have checked and found that the name is appropriate and that the project has a legal license to continue using its current name. No other items with this name were found in Google search.

### Orphaned products

Ptubes团队的核心开发人员均在这个项目上全职工作，Ptubes 成为孤儿的风险很小，美团作为中国互联网的领导者之一，正在广泛的使用Ptubes。目前Ptubes每天处理接近万亿个事件。为2万多个核心应用提供服务。我们计划通过 Apache 进一步扩展和多样化这个社区。

The core developers of the Ptubes team are all working full-time on the project, so the risk of Ptubes becoming an orphan is low, and Meituan, one of the leaders of the Chinese Internet, is using Ptubes extensively.

Currently Ptubes processes close to a trillion events per day. Serves more than 20,000 core applications. We plan to further expand and diversify this community through Apache.

### Inexperience with Open Source

核心开发者都是开源的活跃用户和追随者。他们也是 Ptubes 项目的提交者和贡献者，所有人都参与了在开源许可下发布的源代码，其中一些人还具有在开源环境中开发代码的经验。尽管核心开发人员在 ASF 方面没有经验，但有计划让具有 ASF 开源经验的个人加入该项目。

The core developers are active users and followers of open source. They are also committers and contributors to the Ptubes project, all of whom have participated in the release of source code under an open source license, some of whom also have experience developing code in an open source environment. Although the core developers have no experience with ASF, there are plans to have individuals with ASF open source experience join the project.

### Homogenous Developers

目前，Ptubes项目核心开发者主要来自美团。我们正在努力吸引外部开发者，我们希望与更多外部开发一起建设 Ptubes 社区，并在他们做出重要贡献时培养他们成为提交者。

Now, the core developers of the Ptubes project are mainly from Meituan. We are working hard to attract external developers, and we hope to build the Ptubes community with more external developers and nurture them as committers when they make important contributions.

### Reliance on Salaried Developers

Ptubes的贡献者由他们的雇主支付费用。Ptubes对贡献者工作的公司非常重要，这将促进社区更好地发展。同时，我们期待吸引更多美团以外的人为这个项目做出贡献，只要他们对 Ptubes 项目有热情，我们愿意与之一起建设Ptubes 社区。

另外，大多数贡献者都是在基础架构领域工作的，所以无论他们是否会离开现在的雇主，他们都不会离开自己的核心工作领域。因此无论是否受薪，他们都将继续参与项目。

Some members of the committers are paid by their employers to contribute to Ptubes. Ptubes are very important to the companies where the contributors work, which will facilitate the better development of the community. At the same time, we look forward to attracting more people outside of Meituan to contribute to this project. As long as they are enthusiastic about the Ptubes project, we are willing to build the Ptubes community with them.

More, most of the contributors work in the infrastructure area, so whether or not they leave their current employer, they're not leaving their core area of work. So they will continue to participate in the project whether they are paid or not.

### Relationships with Other Apache Products

在Google搜索引擎暂无搜索到同类型产品。

There are no similar products found in the Google search.

### A Excessive Fascination with the Apache Brand

Ptubes 提议进入 Apache 孵化，以期待吸引更多元的提交者参与进来，并达到丰富产品形态的目的，而不是利用 Apache 品牌实现商业目的。Ptubes 项目已在美团生产环境中广泛使用，但不会成为面向外部客户的美团产品。因此，Ptubes 项目并不寻求将 Apache 品牌用作营销工具。

Ptubes proposes to enter the Apache incubator, hoping to attract more diverse submitters to participate and achieve the purpose of enriching the product form, rather than using the Apache brand for commercial purposes. The Ptubes project has been widely used in the Meituan production environment, but will not be a Meituan product for external customers. Therefore, the Ptubes project does not seek to use the Apache brand as a marketing tool.

## Documentation

Information about Ptubes can be found on the Github project wiki \[https://github.com/meituan/ptubes/wiki\]

## Initial Source

Ptubes has been under development at Meituan since 2015. The source code was opened up in 2022. It is currently hosted on Github using the Apache License (\[https://github.com/meituan/ptubes/blob/master/LICENSE\]).

## Source and Intellectual Property Submission Plan

目前代码是 Apache 2.0 许可的，版权归美团所有。如果项目进入孵化器，美团将通过软件授权协议将源代码和商标所有权转让给 ASF。

The current code is licensed under Apache 2.0, and the copyright belongs to Meituan. If the project enters the incubator, Meituan will transfer the source code and trademark ownership to ASF through a software license agreement.

## External Dependencies

Ptubes depends on some Apache projects:

* commons
* helix
* zookeeper
* Maven

and other open source projects (organized by license):ALv2：

* com.101tec:zkclient
* jackson
* guava
* protobuf
* grpc
* fastjson
* log4j
* apache.httpcomponents
* com.lmax.disruptor
* io.netty
* org.apache.avro
* codehaus.groovy

EPL：

* junit
* logback
* com.vividsolutions

MIT：

* slf4j

As all dependencies are managed using Apache Maven, none of the external libraries need to be packaged in a source distribution.

## Required Resources

### Mailing lists

暂无

### Git Repositories

Git is the preferred source control management system: https://github.com/meituan/ptubes

### Issue Tracking

The community would like to continue using GitHub Issues (will be moved togithub.com/apache).

### Other Resources

社区已经选择了 GitHub社区 作为持续集成工具。

社区已经使用 mvn 作为二进制包发布平台。

		We has chosen GitHub Community as the continuous integration tool.
	
		We has used mvn as a platform for binary package distribution.
	

## Initial Committers

* Songshu Zhang zsongshu@gmail.com
* Fei Lv lfei02758@gmail.com
* Yang Yang yangyangksl@gmail.com
* Shance Wang wangshance@gmail.com
* Hui Wang wangfancying@gmail.com
* Hao Kong q422243639@gmail.com
* Kai Li <kayaklee>

## Affiliations

* Songshu Zhang : Meituan
* Fei Lv : Meituan
* Yang Yang : Meituan
* Shance Wang : Meituan
* Hui Wang : Meituan
* Hao Kong : Meituan
* Kai Li : Meituan

## Sponsors

### Champion

潘娟

### Nominated Mentors

吴晟

王小瑞

张亮

贺小桥

### Sponsoring Entity

我们期待 Apache 孵化器能够赞助这个项目。

1、开发者2、关系

%23%23%20Abstract%0APtubes%E6%98%AF%E4%B8%80%E6%AC%BE%E5%9F%BA%E4%BA%8EPITR%EF%BC%88Point%20In%20Time%20Recovery%EF%BC%89%E6%96%B9%E5%BC%8F%E5%AE%9E%E7%8E%B0%E7%9A%84%E6%95%B0%E6%8D%AE%E5%BA%93%E7%81%BE%E5%A4%87%E4%BA%A7%E5%93%81%EF%BC%8C%E5%8F%AF%E7%94%A8%E4%BA%8E%E5%B0%86%E6%95%B4%E4%B8%AA%E6%95%B0%E6%8D%AE%E5%BA%93%E8%BF%98%E5%8E%9F%E5%88%B0%E7%89%B9%E5%AE%9A%E7%9A%84%E6%97%B6%E9%97%B4%E7%82%B9%EF%BC%8C%E5%B8%AE%E5%8A%A9%E4%BD%BF%E7%94%A8%E8%80%85%E6%8F%90%E5%8D%87%E6%95%B0%E6%8D%AE%E5%BA%93%E7%9A%84%E5%8F%AF%E9%9D%A0%E6%80%A7%E5%92%8C%E5%AE%89%E5%85%A8%E6%80%A7%E3%80%82%0A%0APtubes%E6%8F%90%E4%BE%9B%E4%BA%86%E6%95%B0%E6%8D%AE%E5%BA%93%E5%8F%98%E6%9B%B4%E4%BA%8B%E4%BB%B6%E5%AE%89%E5%85%A8%E5%A4%87%E4%BB%BD%E3%80%81%E9%AB%98%E6%95%88%E5%88%86%E5%8F%91%E7%AD%89%E5%8A%9F%E8%83%BD%EF%BC%8C%E5%8F%AF%E5%B9%BF%E6%B3%9B%E5%BA%94%E7%94%A8%E4%BA%8E%E6%95%B0%E6%8D%AE%E5%A4%87%E4%BB%BD%E3%80%81%E6%95%B0%E6%8D%AE%E6%81%A2%E5%A4%8D%E3%80%81%E6%95%B0%E6%8D%AE%E5%9B%9E%E6%94%BE%E3%80%81%E4%BA%8B%E4%BB%B6%E9%A9%B1%E5%8A%A8%E3%80%81%E6%95%B0%E6%8D%AE%E5%BA%93%E5%A4%9A%E6%B4%BB%E7%AD%89%E5%9C%BA%E6%99%AF%E3%80%82%0A%0APtubes%20is%20a%20database%20disaster%20recovery%20product%20based%20on%20PITR%20(Point%20In%20Time%20Recovery)%2C%20which%20can%20be%20used%20to%20restore%20the%20database%20to%20a%20specific%20point%20in%20time%20and%20help%20users%20improve%20the%20reliability%20and%20security%20of%20the%20database.%0A%0APtubes%20provides%20functions%20such%20as%20secure%20backup%20and%20efficient%20distribution%20of%20database%20change%20events(binary%20log%2C%20binlog)%2C%20which%20can%20be%20widely%20used%20in%20scenarios%20such%20as%20data%20backup%2C%20data%20recovery%2C%20data%20playback%2C%20event-driven%2C%20and%20database%20Multi-Site%20High%20Availability.%0A%0A%0A%0A%23%23%20Proposal%0A%0A%23%23%20Ptubes%0A%0APtubes%E4%BB%A5%E5%85%B3%E7%B3%BB%E5%9E%8B%E6%95%B0%E6%8D%AE%E5%BA%93%EF%BC%88%E4%BE%8B%E5%A6%82Mysql%E3%80%81Postgresql%EF%BC%89%E7%9A%84%E5%9C%A8%E7%BA%BF%E5%8F%98%E6%9B%B4%E6%97%A5%E5%BF%97%E4%BD%9C%E4%B8%BA%E6%95%B0%E6%8D%AE%E6%BA%90%EF%BC%8C%E5%AE%9E%E6%97%B6%E8%8E%B7%E5%8F%96%E5%A2%9E%E9%87%8F%E5%8F%98%E6%9B%B4%E6%97%A5%E5%BF%97%EF%BC%8C%E5%B9%B6%E5%B0%86%E5%85%B6%E5%AD%98%E5%82%A8%E5%88%B0%E6%9C%AC%E5%9C%B0%E6%88%96%E8%BF%9C%E7%A8%8B%E4%BA%91%E7%9B%98%E3%80%82%0A%0APtubes%E9%87%87%E7%94%A8%E4%BA%86%E7%81%B5%E6%B4%BB%E3%80%81%E5%8F%AF%E7%BA%BF%E6%80%A7%E6%89%A9%E5%B1%95%E7%9A%84%E5%88%86%E5%B8%83%E5%BC%8F%E8%B0%83%E5%BA%A6%E6%A1%86%E6%9E%B6%EF%BC%8C%E4%BB%A5%E5%8F%8A%E9%80%9A%E8%BF%87%E9%AB%98%E6%95%88%E7%9A%84%E6%95%B0%E6%8D%AE%E5%88%86%E5%8F%91%E5%8D%8F%E8%AE%AE%EF%BC%8C%E4%B8%A5%E6%A0%BC%E9%81%B5%E5%BE%AA%E5%8E%9F%E5%A7%8B%E6%95%B0%E6%8D%AE%E7%9A%84%E4%BA%8B%E5%8A%A1%E4%B8%80%E8%87%B4%E6%80%A7%EF%BC%8C%E6%8A%8A%E6%95%B0%E6%8D%AE%E7%A7%92%E7%BA%A7%E5%A4%87%E4%BB%BD%E5%88%B0%E5%A4%9A%E7%A7%8D%E5%AD%98%E5%82%A8%E4%BB%8B%E8%B4%A8%EF%BC%8C%E4%B9%9F%E5%8F%AF%E4%BB%A5%E4%BD%BF%E7%94%A8%E6%97%A5%E5%BF%97%E6%8A%8A%E6%95%B0%E6%8D%AE%E5%BA%93%E4%BF%AE%E5%A4%8D%E5%88%B0%E6%8C%87%E5%AE%9A%E7%9A%84%E6%97%B6%E9%97%B4%E7%82%B9%E3%80%82%0A%0APtubes%E6%98%AF%E7%BE%8E%E5%9B%A2%E5%AE%9E%E7%8E%B0%E6%95%B0%E6%8D%AE%E5%AE%B9%E7%81%BE%E7%9A%84%E5%9F%BA%E7%A1%80%E7%BB%84%E4%BB%B6%EF%BC%8C%E6%AF%8F%E5%A4%A9%E5%A4%84%E7%90%86%E4%BA%86%E8%BF%91%E4%B8%87%E4%BA%BF%E8%A1%8C%E6%95%B0%E6%8D%AE%E3%80%82%E6%88%91%E4%BB%AC%E5%B8%8C%E6%9C%9B%E5%8A%A0%E5%85%A5ASF%E4%B9%8B%E5%90%8E%EF%BC%8C%E5%8F%AF%E4%BB%A5%E6%8E%A8%E5%8A%A8Ptubes%E6%9C%9D%E7%9D%80%E6%9B%B4%E5%A4%9A%E6%A0%B7%E5%8C%96%E3%80%81%E6%9B%B4%E5%9B%BD%E9%99%85%E5%8C%96%E7%9A%84%E6%96%B9%E5%90%91%E5%8F%91%E5%B1%95%EF%BC%8C%E6%9E%84%E5%BB%BA%E4%B8%80%E4%B8%AA%E5%AE%8C%E5%96%84%E7%9A%84%E6%95%B0%E6%8D%AE%E7%81%BE%E5%A4%87%E9%A2%86%E5%9F%9F%E7%9A%84%E5%BC%80%E6%BA%90%E7%A4%BE%E5%8C%BA%E3%80%82%0A%0APtubes%20uses%20the%20binlog%20of%20relational%20databases%20(such%20as%20Mysql%2C%20Postgresql)%20as%20the%20data%20source%2C%20obtains%20the%20incremental%20change%20log%20in%20real%20time%2C%20and%20stores%20it%20in%20the%20local%20or%20remote%20cloud%20drive.%0A%0APtubes%20adopts%20a%20flexible%20and%20linearly%20scalable%20distributed%20scheduling%20framework%2C%20and%20through%20an%20efficient%20data%20distribution%20protocol%2C%20strictly%20follows%20the%20transaction%20consistency%20of%20the%20original%20data%2C%20backs%20up%20the%20data%20to%20a%20variety%20of%20storage%20media%20in%20seconds%2C%20and%20can%20also%20use%20the%20log%20to%20restore%20the%20database%20to%20specified%20point%20in%20time.%0A%0APtubes%20is%20the%20basic%20components%20for%20Meituan%20to%20achieve%20data%20disaster%20recovery%2C%20processing%20nearly%20one%20trillion%20rows%20of%20data%20every%20day.%20We%20hope%20that%20after%20joining%20ASF%2C%20we%20can%20push%20Ptubes%20towards%20a%20more%20diversified%20and%20international%20direction%20and%20build%20a%20perfect%20open%20source%20community%20in%20data%20disaster%20recovery.%0A%0A%23%23%20Background%0APtubes%20%E4%BB%8E2015%E5%B9%B4%E5%BC%80%E5%A7%8B%E5%9C%A8%E7%BE%8E%E5%9B%A2%E7%AB%8B%E9%A1%B9%E5%BC%80%E5%8F%91%EF%BC%8C%E4%BB%8E%E9%82%A3%E6%97%B6%E8%B5%B7%E4%B8%80%E7%9B%B4%E5%9C%A8%E7%BE%8E%E5%9B%A2%E7%9A%84%E7%94%9F%E4%BA%A7%E7%8E%AF%E5%A2%83%E4%B8%AD%E4%BD%BF%E7%94%A8%EF%BC%8C%E8%A6%86%E7%9B%96%E4%BA%86%E4%B8%8A%E4%B8%87%E4%B8%AAMysql%E9%9B%86%E7%BE%A4%EF%BC%8C%E4%B8%BA%E5%90%84%E4%B8%9A%E5%8A%A1%E5%9B%A2%E9%98%9F%E6%8F%90%E4%BE%9B%E4%BA%86%E5%8F%AF%E9%9D%A0%E3%80%81%E9%AB%98%E6%95%88%E7%9A%84%E6%95%B0%E6%8D%AE%E5%BA%93%E5%8F%98%E6%9B%B4%E6%97%A5%E5%BF%97%E7%9A%84%E5%AD%98%E5%82%A8%E5%92%8C%E5%88%86%E5%8F%91%E6%9C%8D%E5%8A%A1%EF%BC%8C%E5%90%8C%E6%97%B6%E4%B9%9F%E6%98%AF%E7%BE%8E%E5%9B%A2%E5%BC%82%E5%9C%B0%E5%A4%9A%E6%B4%BB%E5%B7%A5%E7%A8%8B%E7%9A%84%E6%A0%B8%E5%BF%83%E5%9F%BA%E7%A1%80%E7%BB%84%E4%BB%B6%EF%BC%8C%E6%94%AF%E6%8C%81%E4%BA%86%E5%A4%96%E5%8D%96%E7%AD%89%E5%A4%9A%E4%B8%AA%E4%B8%9A%E5%8A%A1%E7%B3%BB%E7%BB%9F%E7%9A%84%E5%BC%82%E5%9C%B0%E5%AE%B9%E7%81%BE%E6%9E%B6%E6%9E%84%E5%8D%87%E7%BA%A7%E3%80%82%0A%0A%E5%A6%82%E4%BB%8A%EF%BC%8C%E5%9C%A8%E7%BE%8E%E5%9B%A2%EF%BC%8CPtubes%20%E9%9B%86%E7%BE%A4%E6%AF%8F%E5%A4%A9%E5%A4%84%E7%90%86%E6%8E%A5%E8%BF%91%E4%B8%87%E4%BA%BF%E4%B8%AA%E4%BA%8B%E4%BB%B6%E3%80%82%E4%B8%BA2%E4%B8%87%E5%A4%9A%E4%B8%AA%E6%A0%B8%E5%BF%83%E5%BA%94%E7%94%A8%E6%8F%90%E4%BE%9B%E6%9C%8D%E5%8A%A1%E3%80%82%E6%88%91%E4%BB%AC%E7%9B%B8%E4%BF%A1%20Ptubes%20%E5%8F%AF%E4%BB%A5%E9%80%A0%E7%A6%8F%E6%9B%B4%E5%A4%9A%E7%9A%84%E4%BA%BA%EF%BC%8C%E6%89%80%E4%BB%A5%E6%88%91%E4%BB%AC%E6%84%BF%E6%84%8F%E9%80%9A%E8%BF%87%20ASF%20%E5%88%86%E4%BA%AB%E5%AE%83%EF%BC%8C%E5%B9%B6%E9%80%9A%E8%BF%87%20The%20Apache%20Way%20%E5%BC%80%E5%A7%8B%E5%BC%80%E5%8F%91%E4%B8%80%E4%B8%AA%E5%BC%80%E5%8F%91%E8%80%85%E5%92%8C%E7%94%A8%E6%88%B7%E7%A4%BE%E5%8C%BA%E3%80%82%0A%0APtubes%20has%20been%20developed%20in%20Meituan%20since%202015%2C%20and%20has%20been%20used%20in%20the%20production%20environment%20of%20Meituan%20since%20then%2C%20covering%20tens%20of%20thousands%20of%20Mysql%20clusters%2C%20providing%20various%20business%20teams%20with%20reliable%20and%20efficient%20storage%20and%20distribution%20of%20database%20change%20logs%20Service%20is%20also%20the%20core%20basic%20component%20of%20Meituan's%20remote%20multi-activity%20project%2C%20which%20supports%20the%20remote%20disaster%20recovery%20architecture%20upgrade%20of%20multiple%20business%20systems%20such%20as%20food%20delivery.%0A%0AToday%2C%20at%20Meituan%2C%20the%20Ptubes%20cluster%20processes%20close%20to%20a%20trillion%20events%20per%20day.%20Serves%20more%20than%2020%2C000%20core%20applications.%20We%20believe%20that%20Ptubes%20can%20benefit%20more%20people%2C%20so%20we%20are%20willing%20to%20share%20it%20through%20ASF%20and%20start%20developing%20a%20community%20of%20developers%20and%20users%20through%20The%20Apache%20Way.%0A%0A%0A%23%23%20Rationale%0A%E9%80%9A%E8%BF%87Ptubes%EF%BC%8C%E4%BD%BF%E7%94%A8%E8%80%85%E5%8F%AF%E4%BB%A5%E7%AE%80%E5%8D%95%E3%80%81%E7%81%B5%E6%B4%BB%E7%9A%84%E6%89%93%E9%80%A0%E5%B1%9E%E4%BA%8E%E8%87%AA%E5%B7%B1%E7%9A%84%E6%95%B0%E6%8D%AE%E5%BA%93%E7%81%BE%E5%A4%87%E4%BA%A7%E5%93%81%EF%BC%8C%E8%A7%A3%E5%86%B3%E5%9C%A8%E7%A0%94%E5%8F%91%E3%80%81%E7%94%9F%E4%BA%A7%E8%BF%87%E7%A8%8B%E4%B8%AD%E9%81%87%E5%88%B0%E7%9A%84%E5%90%84%E7%A7%8D%E6%95%B0%E6%8D%AE%E5%AE%B9%E7%81%BE%E9%97%AE%E9%A2%98%E3%80%82%E6%88%91%E4%BB%AC%E9%A2%84%E8%AE%A1%E5%AE%83%E4%BC%9A%E8%A2%AB%E8%B5%8B%E4%BA%88%E8%AE%B8%E5%A4%9A%E6%96%B0%E7%89%B9%E6%80%A7%EF%BC%8CPtubes%E4%B9%9F%E4%BC%9A%E6%8C%81%E7%BB%AD%E8%BF%AD%E4%BB%A3%E5%92%8C%E5%A2%9E%E5%BC%BA%E4%BA%A7%E5%93%81%E7%9A%84%E5%9F%BA%E7%A1%80%E8%83%BD%E5%8A%9B%EF%BC%8C%E4%BE%BF%E4%BA%8E%E5%A4%A7%E5%AE%B6%E6%8E%A5%E5%8F%97%E5%92%8C%E4%BD%BF%E7%94%A8%E3%80%82%0A%0AThrough%20Ptubes%2C%20users%20can%20simply%20and%20flexibly%20create%20their%20own%20database%20disaster%20recovery%20products%20to%20solve%20various%20data%20disaster%20recovery%20problems%20encountered%20in%20the%20process%20of%20R%26D%20and%20production.%20We%20expect%20that%20it%20will%20be%20endowed%20with%20many%20new%20features%2C%20and%20Ptubes%20will%20continue%20to%20iterate%20and%20enhance%20the%20basic%20capabilities%20of%20the%20product%20for%20everyone%20to%20accept%20and%20use.%0A%0A%23%23%20Initial%20Goals%0A%E8%99%BD%E7%84%B6%20Ptubes%20%E7%9A%84%E5%A4%A7%E9%83%A8%E5%88%86%E4%B8%BB%E8%A6%81%E5%BC%80%E5%8F%91%E5%B7%B2%E7%BB%8F%E5%AE%8C%E6%88%90%EF%BC%8C%E4%BD%86%E4%BB%8D%E6%9C%89%E5%87%A0%E4%B8%AA%E5%8A%9F%E8%83%BD%E7%82%B9%E9%9C%80%E8%A6%81%E8%BF%9B%E4%B8%80%E6%AD%A5%E5%A2%9E%E5%BC%BA%E3%80%82%E6%88%91%E4%BB%AC%E5%B8%8C%E6%9C%9B%E5%9C%A8%20Apache%20%E5%AD%B5%E5%8C%96%E9%98%B6%E6%AE%B5%E5%85%B3%E6%B3%A8%E7%9A%84%E4%B8%80%E4%BA%9B%E9%A2%86%E5%9F%9F%E5%8C%85%E6%8B%AC%EF%BC%9A%20%0A%0A\*%20%E6%94%AF%E6%8C%81%E6%9B%B4%E5%A4%9A%E6%A0%B7%E7%9A%84%E6%95%B0%E6%8D%AE%E5%BA%93%E5%BC%95%E6%93%8E%EF%BC%8C%E6%89%A9%E5%B1%95%E4%BA%A7%E5%93%81%E7%9A%84%E5%BA%94%E7%94%A8%E8%8C%83%E5%9B%B4%0A%0A\*%20%E4%B8%B0%E5%AF%8C%E5%AF%B9%E4%BA%8E%E6%95%B0%E6%8D%AE%E5%BA%93%E6%97%A5%E5%BF%97%E7%9A%84%E8%AE%A1%E7%AE%97%E8%83%BD%E5%8A%9B%EF%BC%8C%E4%BE%BF%E4%BA%8E%E7%94%A8%E6%88%B7%E9%80%82%E9%85%8D%E4%B8%AA%E6%80%A7%E5%8C%96%E7%9A%84%E6%95%B0%E6%8D%AE%E6%A8%A1%E5%9E%8B%0A%0A\*%20%E6%8F%90%E4%BE%9B%E7%8B%AC%E7%AB%8B%E7%9A%84%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E6%9C%8D%E5%8A%A1%EF%BC%8C%E4%BE%BF%E4%BA%8E%E7%94%A8%E6%88%B7%E6%9B%B4%E8%BD%BB%E9%87%8F%E7%9A%84%E6%8A%8APtubes%E8%BF%90%E8%A1%8C%E8%B5%B7%E6%9D%A5%0A%0AWhile%20most%20of%20the%20major%20development%20of%20Ptubes%20has%20been%20completed%2C%20there%20are%20still%20several%20functional%20points%20that%20need%20further%20enhancements.%20Some%20of%20the%20areas%20we%20hope%20to%20focus%20on%20during%20the%20Apache%20incubation%20phase%20include%3A%0A%0A\*%20Support%20more%20diverse%20database%20engines%20to%20expand%20the%20application%20scope%20of%20the%20product%0A%0A\*%20Enriching%20the%20computing%20power%20for%20database%20logs%2C%20making%20it%20easy%20for%20users%20to%20adapt%20to%20personalized%20data%20models%0A%0A\*%20Provide%20independent%20load%20balancing%20service%20to%20facilitate%20the%20lightweight%20operation%20of%20Ptubes%0A%0A%23%23%20Current%20Status%0A%23%23%23%20Meritocracy%0A%E5%9C%A8%E8%BF%87%E5%8E%BB%E7%9A%84%E5%87%A0%E5%B9%B4%EF%BC%8CPtubes%E4%B8%80%E7%9B%B4%E4%BD%9C%E4%B8%BA%E5%86%85%E9%83%A8%E4%BA%A7%E5%93%81%E4%B8%BA%E7%BE%8E%E5%9B%A2%E7%9A%84%E4%B8%9A%E5%8A%A1%E7%B3%BB%E7%BB%9F%E6%8F%90%E4%BE%9B%E6%9C%8D%E5%8A%A1%EF%BC%8C%E8%BF%91%E6%9C%9F%E5%9C%A8%E7%BE%8E%E5%9B%A2%E5%9F%BA%E7%A1%80%E6%8A%80%E6%9C%AF%E9%83%A8%E9%97%A8%E7%9A%84%E5%A4%A7%E5%8A%9B%E6%94%AF%E6%8C%81%E4%B8%8B%E5%86%B3%E5%AE%9A%E5%BC%80%E6%BA%90%EF%BC%8C%E7%9B%AE%E7%9A%84%E6%98%AF%E6%9C%9F%E6%9C%9B%E6%8A%8A%E5%9C%A8%E7%BE%8E%E5%9B%A2%E7%BB%8F%E5%8E%86%E8%BF%87%E5%85%85%E5%88%86%E9%AA%8C%E8%AF%81%E7%9A%84%E4%BA%A7%E5%93%81%E8%83%BD%E5%8A%9B%E8%BE%93%E5%87%BA%E5%88%B0%E7%A4%BE%E5%8C%BA%EF%BC%8C%E4%BB%A5%E5%B8%AE%E5%8A%A9%E6%9B%B4%E5%A4%9A%E7%9A%84%E5%BC%80%E5%8F%91%E8%80%85%E4%BB%A5%E4%BD%8E%E6%88%90%E6%9C%AC%E8%8E%B7%E5%BE%97%E5%8F%AF%E9%9D%A0%E7%9A%84%E6%95%B0%E6%8D%AE%E5%AE%B9%E7%81%BE%E6%9C%8D%E5%8A%A1%EF%BC%8C%E5%B9%B6%E4%B8%94%E9%9A%8F%E7%9D%80%E8%B6%8A%E6%9D%A5%E8%B6%8A%E5%A4%9A%E7%9A%84%E5%BC%80%E5%8F%91%E8%80%85%E5%8F%82%E4%B8%8E%E5%85%B6%E4%B8%AD%EF%BC%8C%E4%BA%A7%E5%93%81%E5%BD%A2%E6%80%81%E4%B9%9F%E5%8F%AF%E4%BB%A5%E6%9B%B4%E5%8A%A0%E4%B8%B0%E5%AF%8C%E5%92%8C%E6%88%90%E7%86%9F%E3%80%82%E6%88%91%E4%BB%AC%E5%B0%86%E6%8C%89%E7%85%A7%20Apache%20%E7%9A%84%E7%B2%BE%E8%8B%B1%E7%AE%A1%E7%90%86%E6%96%B9%E5%BC%8F%E7%BB%84%E7%BB%87%E7%A4%BE%E5%8C%BA%E8%A7%92%E8%89%B2%EF%BC%8C%E4%B8%BA%E4%BA%A7%E5%93%81%E8%B4%A1%E7%8C%AE%E8%80%85%E5%92%8C%E7%A4%BE%E5%8C%BA%E5%8F%82%E4%B8%8E%E8%80%85%E6%8F%90%E4%BE%9B%E5%8F%8A%E6%97%B6%E8%AF%A6%E5%B0%BD%E7%9A%84%E6%8A%80%E6%9C%AF%E6%94%AF%E6%8C%81%EF%BC%8C%E5%B9%B6%E4%B8%8E%E9%82%A3%E4%BA%9B%E5%AF%B9%E9%A1%B9%E7%9B%AE%E5%81%9A%E5%87%BA%E9%87%8D%E5%A4%A7%E8%B4%A1%E7%8C%AE%E7%9A%84%E4%BA%BA%E5%90%88%E4%BD%9C%EF%BC%8C%E9%BC%93%E5%8A%B1%E4%BB%96%E4%BB%AC%E6%88%90%E4%B8%BA%E6%8F%90%E4%BA%A4%E8%80%85%E3%80%82%0A%0AIn%20the%20past%20few%20years%2C%20Ptubes%20has%20been%20providing%20services%20for%20Meituan's%20business%20system%20as%20an%20internal%20product.%20Recently%2C%20with%20the%20strong%20support%20of%20Meituan's%20basic%20technology%20department%2C%20it%20has%20decided%20to%20open%20source.%20The%20purpose%20is%20to%20export%20products%20that%20have%20been%20fully%20verified%20in%20Meituan%20to%20the%20community%20and%20help%20more%20developers%20obtain%20reliable%20data%20disaster%20recovery%20services%20at%20low%20cost%2C%20and%20as%20more%20and%20more%20developers%20participate%2C%20the%20product%20form%20can%20be%20more%20abundant%20and%20mature.%20We%20will%20organize%20community%20roles%20according%20to%20Apache's%20meritocracy%2C%20provide%20timely%20and%20detailed%20technical%20support%20to%20product%20contributors%20and%20community%20participants%2C%20and%20work%20with%20those%20who%20have%20made%20significant%20contributions%20to%20the%20project%20to%20encourage%20them%20to%20become%20committers.%0A%23%23%23%20Community%0APtubes%20%E7%9B%AE%E5%89%8D%E7%94%B1%E7%BE%8E%E5%9B%A2%E7%9A%84%E5%B7%A5%E7%A8%8B%E5%B8%88%E5%BC%80%E5%8F%91%EF%BC%8C%E8%A2%AB%E5%90%84%E4%B8%9A%E5%8A%A1%E7%B3%BB%E7%BB%9F%E9%AB%98%E5%BA%A6%E4%BE%9D%E8%B5%96%E5%92%8C%E4%BD%BF%E7%94%A8%E3%80%82%E7%8E%B0%E5%9C%A8%E6%88%91%E4%BB%AC%E4%BD%BF%E7%94%A8GitHub%20%E8%BF%9B%E8%A1%8C%E4%BB%A3%E7%A0%81%E6%89%98%E7%AE%A1%E5%92%8C%E7%A4%BE%E5%8C%BA%E4%BA%A4%E6%B5%81%EF%BC%8C%E6%88%91%E4%BB%AC%E5%B8%8C%E6%9C%9B%E9%80%9A%E8%BF%87%E9%82%80%E8%AF%B7%E6%89%80%E6%9C%89%E9%80%9A%E8%BF%87%E4%BD%BF%E7%94%A8%20Apache%20Way%20%E5%81%9A%E5%87%BA%E9%87%8D%E5%A4%A7%E8%B4%A1%E7%8C%AE%E5%B9%B6%E8%A1%A8%E7%8E%B0%E5%87%BA%E8%89%B2%E7%9A%84%E4%BA%BA%E6%9D%A5%E6%89%A9%E5%A4%A7%E8%B4%A1%E7%8C%AE%E8%80%85%E3%80%82%20Ptubes%E9%A1%B9%E7%9B%AE%E5%B7%B2%E7%BB%8F%E5%87%86%E5%A4%87%E5%A5%BD%E6%8E%A5%E5%8F%97%E6%9D%A5%E8%87%AA%E5%90%84%E8%A1%8C%E5%90%84%E4%B8%9A%E7%9A%84%E5%BC%80%E5%8F%91%E8%80%85%E5%8F%82%E4%B8%8E%E8%BF%9B%E6%9D%A5%EF%BC%8C%E4%B8%BA%E4%BA%86%E8%BF%9B%E4%B8%80%E6%AD%A5%E5%AE%9E%E7%8E%B0%E8%BF%99%E4%B8%80%E7%9B%AE%E6%A0%87%EF%BC%8C%E8%AF%A5%E9%A1%B9%E7%9B%AE%E7%9B%AE%E5%89%8D%E5%88%A9%E7%94%A8%20GitHub%20%E9%A1%B9%E7%9B%AE%E5%8A%9F%E8%83%BD%E4%BB%A5%E5%8F%8A%E9%80%9A%E8%BF%87%20Google%20Groups%20%E6%8F%90%E4%BE%9B%E7%9A%84%E5%85%AC%E5%85%B1%E9%82%AE%E4%BB%B6%E5%88%97%E8%A1%A8%E3%80%82%0A%0APtubes%20are%20currently%20developed%20by%20Meituan%20engineers%20and%20are%20highly%20relied%20upon%20and%20used%20by%20various%20business%20systems.%20Now%20we%20use%20GitHub%20for%20code%20hosting%20and%20community%20communication%2C%20We%20would%20like%20to%20invite%20everyone%20who%20has%20made%20significant%20contributions%20and%20performed%20well%20using%20the%20Apache%20Way%20to%20expand%20contributors.%20The%20Ptubes%20project%20is%20ready%20to%20accept%20participation%20from%20developers%20from%20all%20walks%20of%20life%2C%20and%20to%20further%20this%20goal%2C%20the%20project%20currently%20utilizes%20the%20GitHub%20project%20functionality%20as%20well%20as%20a%20public%20mailing%20list%20via%20Google%20Groups.%0A%23%23%23%20Core%20Developers%3A%0A%E7%9B%AE%E5%89%8D%EF%BC%8CPtubes%E7%9A%84%E6%A0%B8%E5%BF%83%E5%BC%80%E5%8F%91%E4%BA%BA%E5%91%98%E5%9D%87%E6%9D%A5%E8%87%AA%E7%BE%8E%E5%9B%A2%E6%95%B0%E6%8D%AE%E5%BA%93%E5%9B%A2%E9%98%9F%EF%BC%8C%E5%9B%A2%E9%98%9F%E6%88%90%E5%91%98%E5%9D%87%E5%85%B7%E5%A4%87%E5%A4%9A%E5%B9%B4%E6%95%B0%E6%8D%AE%E5%BA%93%E5%92%8C%E4%B8%AD%E9%97%B4%E4%BB%B6%E7%A0%94%E5%8F%91%E7%BB%8F%E9%AA%8C%E3%80%82%E6%9D%8E%E5%87%AF%E6%98%AF%E7%BE%8E%E5%9B%A2%E6%95%B0%E6%8D%AE%E5%BA%93%E8%B4%9F%E8%B4%A3%E4%BA%BA%EF%BC%8C%E4%B9%9F%E6%98%AF%20OceanBase%E3%80%81TiDB%E7%9A%84%E6%A0%B8%E5%BF%83%E8%B4%A1%E7%8C%AE%E8%80%85%EF%BC%8C%E5%9C%A8%E5%88%86%E5%B8%83%E5%BC%8F%E6%95%B0%E6%8D%AE%E5%BA%93%E9%A2%86%E5%9F%9F%E5%85%B7%E6%9C%89%E5%BE%88%E9%AB%98%E7%9A%84%E5%BD%B1%E5%93%8D%E5%8A%9B%E3%80%82%E5%BC%A0%E6%9D%BE%E6%A0%91%E6%98%AFPtubes%20%E8%B4%9F%E8%B4%A3%E4%BA%BA%EF%BC%8C%E4%B9%9F%E6%98%AFSeata%20%E9%A1%B9%E7%9B%AE%E7%9A%84%E5%8F%91%E8%B5%B7%E8%80%85%E4%B9%8B%E4%B8%80%EF%BC%8C%E6%8B%A5%E6%9C%89%E4%B8%B0%E5%AF%8C%E7%9A%84%E5%BC%80%E6%BA%90%E8%BD%AF%E4%BB%B6%E7%BB%8F%E9%AA%8C%E3%80%82%E5%90%95%E5%A6%83%E3%80%81%E6%9D%A8%E9%98%B3%E3%80%81%E7%8E%8B%E5%96%84%E7%AD%96%E3%80%81%E7%8E%8B%E8%BE%89%E3%80%81%E5%AD%94%E6%B5%A9%EF%BC%8C%E4%BB%8E%E4%BA%8B%E5%88%86%E5%B8%83%E5%BC%8F%E4%B8%AD%E9%97%B4%E4%BB%B6%E8%AE%BE%E8%AE%A1%E4%B8%8E%E7%A0%94%E5%8F%91%E5%A4%9A%E5%B9%B4%EF%BC%8C%E5%AF%B9%E8%BD%AF%E4%BB%B6%E5%B7%A5%E7%A8%8B%E6%9C%89%E7%9D%80%E6%9E%81%E5%A4%A7%E7%9A%84%E7%83%AD%E6%83%85%E3%80%82%0A%0AAt%20present%2C%20the%20core%20developers%20of%20Ptubes%20are%20all%20from%20the%20Meituan%20database%20team%2C%20and%20the%20team%20members%20have%20many%20years%20of%20experience%20in%20database%20and%20middleware%20research%20and%20development.%20%20Kai%20Li%20is%20the%20head%20of%20the%20Meituan%20database%20and%20a%20core%20contributor%20to%20OceanBase%20and%20TiDB.%20He%20has%20a%20high%20influence%20in%20the%20field%20of%20distributed%20databases.%20Songshu%20Zhang%20is%20the%20director%20of%20Ptubes%20and%20one%20of%20the%20initiators%20of%20the%20Seata%20project.%20He%20has%20rich%20experience%20in%20open%20source%20software.%20Fei%20Lv%2C%20Yang%20Yang%2C%20Shance%20Wang%2C%20Hui%20Wang%2C%20and%20%20Hao%20Kong%20have%20been%20engaged%20in%20the%20design%20and%20development%20of%20distributed%20middleware%20for%20many%20years%2C%20and%20have%20great%20enthusiasm%20for%20software%20engineering.%0A%0A%0A%23%23%23%20Alignment%0AASF%20%E6%98%AF%E6%89%98%E7%AE%A1%20Ptubes%20%E9%A1%B9%E7%9B%AE%E7%9A%84%E8%87%AA%E7%84%B6%E9%80%89%E6%8B%A9%EF%BC%8C%E5%9B%A0%E4%B8%BA%E5%AE%83%E9%BC%93%E5%8A%B1%E7%A4%BE%E5%8C%BA%E9%A9%B1%E5%8A%A8%E7%9A%84%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AE%E7%9A%84%E7%9B%AE%E6%A0%87%E7%AC%A6%E5%90%88%E6%88%91%E4%BB%AC%E5%AF%B9%20Ptubes%20%E7%9A%84%E6%84%BF%E6%99%AF%E3%80%82%20ASF%20%E4%B9%9F%E6%98%AFApache%20RocketMQ%E3%80%81Apache%20ShardingSphere%E7%AD%89%E9%A1%B9%E7%9B%AE%E7%9A%84%E6%89%80%E5%9C%A8%E5%9C%B0%E3%80%82%E6%88%91%E4%BB%AC%E8%AE%A1%E5%88%92%E4%B8%8E%E5%AE%83%E4%BB%AC%E9%9B%86%E6%88%90%E5%B9%B6%E5%8D%8F%E5%90%8C%E5%B7%A5%E4%BD%9C%EF%BC%8C%E4%BB%A5%E5%AE%9E%E7%8E%B0%E4%BA%92%E6%83%A0%E4%BA%92%E5%88%A9%E3%80%82%0A%0AASF%20is%20a%20natural%20choice%20for%20hosting%20the%20Ptubes%20project%2C%20as%20it%20encourages%20community-driven%20open%20source%20projects%20whose%20goals%20are%20in%20line%20with%20our%20vision%20for%20Ptubes.%20ASF%20is%20also%20home%20to%20projects%20such%20as%20Apache%20RocketMQ%2C%20Apache%20ShardingSphere.%20We%20plan%20to%20integrate%20and%20work%20with%20them%20for%20mutual%20benefit.%0A%0A%23%23%20Known%20Risks%0A%23%23%23%20Project%20Name%0A%E6%88%91%E4%BB%AC%E5%B7%B2%E7%BB%8F%E6%A3%80%E6%9F%A5%E5%B9%B6%E8%AE%A4%E4%B8%BA%E8%AF%A5%E5%90%8D%E7%A7%B0%E6%98%AF%E5%90%88%E9%80%82%E7%9A%84%EF%BC%8C%E5%B9%B6%E4%B8%94%E8%AF%A5%E9%A1%B9%E7%9B%AE%E5%85%B7%E6%9C%89%E7%BB%A7%E7%BB%AD%E4%BD%BF%E7%94%A8%E5%85%B6%E5%BD%93%E5%89%8D%E5%90%8D%E7%A7%B0%E7%9A%84%E5%90%88%E6%B3%95%E8%AE%B8%E5%8F%AF%E3%80%82%E9%80%9A%E8%BF%87%20Google%20%E6%90%9C%E7%B4%A2%E6%9C%AA%E6%89%BE%E5%88%B0%E4%BD%BF%E7%94%A8%E6%AD%A4%E5%90%8D%E7%A7%B0%E7%9A%84%E5%85%B6%E4%BB%96%E9%A1%B9%E7%9B%AE%E3%80%82%20%20%0A%0AWe%20have%20checked%20and%20found%20that%20the%20name%20is%20appropriate%20and%20that%20the%20project%20has%20a%20legal%20license%20to%20continue%20using%20its%20current%20name.%20No%20other%20items%20with%20this%20name%20were%20found%20in%20Google%20search.%0A%0A%0A%23%23%23%20Orphaned%20products%0APtubes%E5%9B%A2%E9%98%9F%E7%9A%84%E6%A0%B8%E5%BF%83%E5%BC%80%E5%8F%91%E4%BA%BA%E5%91%98%E5%9D%87%E5%9C%A8%E8%BF%99%E4%B8%AA%E9%A1%B9%E7%9B%AE%E4%B8%8A%E5%85%A8%E8%81%8C%E5%B7%A5%E4%BD%9C%EF%BC%8CPtubes%20%E6%88%90%E4%B8%BA%E5%AD%A4%E5%84%BF%E7%9A%84%E9%A3%8E%E9%99%A9%E5%BE%88%E5%B0%8F%EF%BC%8C%E7%BE%8E%E5%9B%A2%E4%BD%9C%E4%B8%BA%E4%B8%AD%E5%9B%BD%E4%BA%92%E8%81%94%E7%BD%91%E7%9A%84%E9%A2%86%E5%AF%BC%E8%80%85%E4%B9%8B%E4%B8%80%EF%BC%8C%E6%AD%A3%E5%9C%A8%E5%B9%BF%E6%B3%9B%E7%9A%84%E4%BD%BF%E7%94%A8Ptubes%E3%80%82%E7%9B%AE%E5%89%8DPtubes%E6%AF%8F%E5%A4%A9%E5%A4%84%E7%90%86%E6%8E%A5%E8%BF%91%E4%B8%87%E4%BA%BF%E4%B8%AA%E4%BA%8B%E4%BB%B6%E3%80%82%E4%B8%BA2%E4%B8%87%E5%A4%9A%E4%B8%AA%E6%A0%B8%E5%BF%83%E5%BA%94%E7%94%A8%E6%8F%90%E4%BE%9B%E6%9C%8D%E5%8A%A1%E3%80%82%E6%88%91%E4%BB%AC%E8%AE%A1%E5%88%92%E9%80%9A%E8%BF%87%20Apache%20%E8%BF%9B%E4%B8%80%E6%AD%A5%E6%89%A9%E5%B1%95%E5%92%8C%E5%A4%9A%E6%A0%B7%E5%8C%96%E8%BF%99%E4%B8%AA%E7%A4%BE%E5%8C%BA%E3%80%82%0A%0AThe%20core%20developers%20of%20the%20Ptubes%20team%20are%20all%20working%20full-time%20on%20the%20project%2C%20so%20the%20risk%20of%20Ptubes%20becoming%20an%20orphan%20is%20low%2C%20and%20Meituan%2C%20one%20of%20the%20leaders%20of%20the%20Chinese%20Internet%2C%20is%20using%20Ptubes%20extensively.%0A%0ACurrently%20Ptubes%20processes%20close%20to%20a%20trillion%20events%20per%20day.%20Serves%20more%20than%2020%2C000%20core%20applications.%20We%20plan%20to%20further%20expand%20and%20diversify%20this%20community%20through%20Apache.%0A%0A%0A%23%23%23%20Inexperience%20with%20Open%20Source%0A%E6%A0%B8%E5%BF%83%E5%BC%80%E5%8F%91%E8%80%85%E9%83%BD%E6%98%AF%E5%BC%80%E6%BA%90%E7%9A%84%E6%B4%BB%E8%B7%83%E7%94%A8%E6%88%B7%E5%92%8C%E8%BF%BD%E9%9A%8F%E8%80%85%E3%80%82%E4%BB%96%E4%BB%AC%E4%B9%9F%E6%98%AF%20Ptubes%20%E9%A1%B9%E7%9B%AE%E7%9A%84%E6%8F%90%E4%BA%A4%E8%80%85%E5%92%8C%E8%B4%A1%E7%8C%AE%E8%80%85%EF%BC%8C%E6%89%80%E6%9C%89%E4%BA%BA%E9%83%BD%E5%8F%82%E4%B8%8E%E4%BA%86%E5%9C%A8%E5%BC%80%E6%BA%90%E8%AE%B8%E5%8F%AF%E4%B8%8B%E5%8F%91%E5%B8%83%E7%9A%84%E6%BA%90%E4%BB%A3%E7%A0%81%EF%BC%8C%E5%85%B6%E4%B8%AD%E4%B8%80%E4%BA%9B%E4%BA%BA%E8%BF%98%E5%85%B7%E6%9C%89%E5%9C%A8%E5%BC%80%E6%BA%90%E7%8E%AF%E5%A2%83%E4%B8%AD%E5%BC%80%E5%8F%91%E4%BB%A3%E7%A0%81%E7%9A%84%E7%BB%8F%E9%AA%8C%E3%80%82%E5%B0%BD%E7%AE%A1%E6%A0%B8%E5%BF%83%E5%BC%80%E5%8F%91%E4%BA%BA%E5%91%98%E5%9C%A8%20ASF%20%E6%96%B9%E9%9D%A2%E6%B2%A1%E6%9C%89%E7%BB%8F%E9%AA%8C%EF%BC%8C%E4%BD%86%E6%9C%89%E8%AE%A1%E5%88%92%E8%AE%A9%E5%85%B7%E6%9C%89%20ASF%20%E5%BC%80%E6%BA%90%E7%BB%8F%E9%AA%8C%E7%9A%84%E4%B8%AA%E4%BA%BA%E5%8A%A0%E5%85%A5%E8%AF%A5%E9%A1%B9%E7%9B%AE%E3%80%82%0A%0AThe%20core%20developers%20are%20active%20users%20and%20followers%20of%20open%20source.%20They%20are%20also%20committers%20and%20contributors%20to%20the%20Ptubes%20project%2C%20all%20of%20whom%20have%20participated%20in%20the%20release%20of%20source%20code%20under%20an%20open%20source%20license%2C%20some%20of%20whom%20also%20have%20experience%20developing%20code%20in%20an%20open%20source%20environment.%20Although%20the%20core%20developers%20have%20no%20experience%20with%20ASF%2C%20there%20are%20plans%20to%20have%20individuals%20with%20ASF%20open%20source%20experience%20join%20the%20project.%0A%0A%0A%23%23%23%20Homogenous%20Developers%0A%E7%9B%AE%E5%89%8D%EF%BC%8CPtubes%E9%A1%B9%E7%9B%AE%E6%A0%B8%E5%BF%83%E5%BC%80%E5%8F%91%E8%80%85%E4%B8%BB%E8%A6%81%E6%9D%A5%E8%87%AA%E7%BE%8E%E5%9B%A2%E3%80%82%E6%88%91%E4%BB%AC%E6%AD%A3%E5%9C%A8%E5%8A%AA%E5%8A%9B%E5%90%B8%E5%BC%95%E5%A4%96%E9%83%A8%E5%BC%80%E5%8F%91%E8%80%85%EF%BC%8C%E6%88%91%E4%BB%AC%E5%B8%8C%E6%9C%9B%E4%B8%8E%E6%9B%B4%E5%A4%9A%E5%A4%96%E9%83%A8%E5%BC%80%E5%8F%91%E4%B8%80%E8%B5%B7%E5%BB%BA%E8%AE%BE%20Ptubes%20%E7%A4%BE%E5%8C%BA%EF%BC%8C%E5%B9%B6%E5%9C%A8%E4%BB%96%E4%BB%AC%E5%81%9A%E5%87%BA%E9%87%8D%E8%A6%81%E8%B4%A1%E7%8C%AE%E6%97%B6%E5%9F%B9%E5%85%BB%E4%BB%96%E4%BB%AC%E6%88%90%E4%B8%BA%E6%8F%90%E4%BA%A4%E8%80%85%E3%80%82%0A%0ANow%2C%20the%20core%20developers%20of%20the%20Ptubes%20project%20are%20mainly%20from%20Meituan.%20We%20are%20working%20hard%20to%20attract%20external%20developers%2C%20and%20we%20hope%20to%20build%20the%20Ptubes%20community%20with%20more%20external%20developers%20and%20nurture%20them%20as%20committers%20when%20they%20make%20important%20contributions.%0A%0A%23%23%23%20Reliance%20on%20Salaried%20Developers%0APtubes%E7%9A%84%E8%B4%A1%E7%8C%AE%E8%80%85%E7%94%B1%E4%BB%96%E4%BB%AC%E7%9A%84%E9%9B%87%E4%B8%BB%E6%94%AF%E4%BB%98%E8%B4%B9%E7%94%A8%E3%80%82Ptubes%E5%AF%B9%E8%B4%A1%E7%8C%AE%E8%80%85%E5%B7%A5%E4%BD%9C%E7%9A%84%E5%85%AC%E5%8F%B8%E9%9D%9E%E5%B8%B8%E9%87%8D%E8%A6%81%EF%BC%8C%E8%BF%99%E5%B0%86%E4%BF%83%E8%BF%9B%E7%A4%BE%E5%8C%BA%E6%9B%B4%E5%A5%BD%E5%9C%B0%E5%8F%91%E5%B1%95%E3%80%82%E5%90%8C%E6%97%B6%EF%BC%8C%E6%88%91%E4%BB%AC%E6%9C%9F%E5%BE%85%E5%90%B8%E5%BC%95%E6%9B%B4%E5%A4%9A%E7%BE%8E%E5%9B%A2%E4%BB%A5%E5%A4%96%E7%9A%84%E4%BA%BA%E4%B8%BA%E8%BF%99%E4%B8%AA%E9%A1%B9%E7%9B%AE%E5%81%9A%E5%87%BA%E8%B4%A1%E7%8C%AE%EF%BC%8C%E5%8F%AA%E8%A6%81%E4%BB%96%E4%BB%AC%E5%AF%B9%20Ptubes%20%E9%A1%B9%E7%9B%AE%E6%9C%89%E7%83%AD%E6%83%85%EF%BC%8C%E6%88%91%E4%BB%AC%E6%84%BF%E6%84%8F%E4%B8%8E%E4%B9%8B%E4%B8%80%E8%B5%B7%E5%BB%BA%E8%AE%BEPtubes%20%E7%A4%BE%E5%8C%BA%E3%80%82%0A%0A%E5%8F%A6%E5%A4%96%EF%BC%8C%E5%A4%A7%E5%A4%9A%E6%95%B0%E8%B4%A1%E7%8C%AE%E8%80%85%E9%83%BD%E6%98%AF%E5%9C%A8%E5%9F%BA%E7%A1%80%E6%9E%B6%E6%9E%84%E9%A2%86%E5%9F%9F%E5%B7%A5%E4%BD%9C%E7%9A%84%EF%BC%8C%E6%89%80%E4%BB%A5%E6%97%A0%E8%AE%BA%E4%BB%96%E4%BB%AC%E6%98%AF%E5%90%A6%E4%BC%9A%E7%A6%BB%E5%BC%80%E7%8E%B0%E5%9C%A8%E7%9A%84%E9%9B%87%E4%B8%BB%EF%BC%8C%E4%BB%96%E4%BB%AC%E9%83%BD%E4%B8%8D%E4%BC%9A%E7%A6%BB%E5%BC%80%E8%87%AA%E5%B7%B1%E7%9A%84%E6%A0%B8%E5%BF%83%E5%B7%A5%E4%BD%9C%E9%A2%86%E5%9F%9F%E3%80%82%E5%9B%A0%E6%AD%A4%E6%97%A0%E8%AE%BA%E6%98%AF%E5%90%A6%E5%8F%97%E8%96%AA%EF%BC%8C%E4%BB%96%E4%BB%AC%E9%83%BD%E5%B0%86%E7%BB%A7%E7%BB%AD%E5%8F%82%E4%B8%8E%E9%A1%B9%E7%9B%AE%E3%80%82%0A%0ASome%20members%20of%20the%20committers%20are%20paid%20by%20their%20employers%20to%20contribute%20to%20Ptubes.%20Ptubes%20are%20very%20important%20to%20the%20companies%20where%20the%20contributors%20work%2C%20which%20will%20facilitate%20the%20better%20development%20of%20the%20community.%20At%20the%20same%20time%2C%20we%20look%20forward%20to%20attracting%20more%20people%20outside%20of%20Meituan%20to%20contribute%20to%20this%20project.%20As%20long%20as%20they%20are%20enthusiastic%20about%20the%20Ptubes%20project%2C%20we%20are%20willing%20to%20build%20the%20Ptubes%20community%20with%20them.%0A%0AMore%2C%20most%20of%20the%20contributors%20work%20in%20the%20infrastructure%20area%2C%20so%20whether%20or%20not%20they%20leave%20their%20current%20employer%2C%20they're%20not%20leaving%20their%20core%20area%20of%20work.%20So%20they%20will%20continue%20to%20participate%20in%20the%20project%20whether%20they%20are%20paid%20or%20not.%0A%0A%0A%23%23%23%20Relationships%20with%20Other%20Apache%20Products%0A%E5%9C%A8Google%E6%90%9C%E7%B4%A2%E5%BC%95%E6%93%8E%E6%9A%82%E6%97%A0%E6%90%9C%E7%B4%A2%E5%88%B0%E5%90%8C%E7%B1%BB%E5%9E%8B%E4%BA%A7%E5%93%81%E3%80%82%0A%0AThere%20are%20no%20similar%20products%20found%20in%20the%20Google%20search.%0A%23%23%23%20A%20Excessive%20Fascination%20with%20the%20Apache%20Brand%0APtubes%20%E6%8F%90%E8%AE%AE%E8%BF%9B%E5%85%A5%20Apache%20%E5%AD%B5%E5%8C%96%EF%BC%8C%E4%BB%A5%E6%9C%9F%E5%BE%85%E5%90%B8%E5%BC%95%E6%9B%B4%E5%A4%9A%E5%85%83%E7%9A%84%E6%8F%90%E4%BA%A4%E8%80%85%E5%8F%82%E4%B8%8E%E8%BF%9B%E6%9D%A5%EF%BC%8C%E5%B9%B6%E8%BE%BE%E5%88%B0%E4%B8%B0%E5%AF%8C%E4%BA%A7%E5%93%81%E5%BD%A2%E6%80%81%E7%9A%84%E7%9B%AE%E7%9A%84%EF%BC%8C%E8%80%8C%E4%B8%8D%E6%98%AF%E5%88%A9%E7%94%A8%20Apache%20%E5%93%81%E7%89%8C%E5%AE%9E%E7%8E%B0%E5%95%86%E4%B8%9A%E7%9B%AE%E7%9A%84%E3%80%82Ptubes%20%E9%A1%B9%E7%9B%AE%E5%B7%B2%E5%9C%A8%E7%BE%8E%E5%9B%A2%E7%94%9F%E4%BA%A7%E7%8E%AF%E5%A2%83%E4%B8%AD%E5%B9%BF%E6%B3%9B%E4%BD%BF%E7%94%A8%EF%BC%8C%E4%BD%86%E4%B8%8D%E4%BC%9A%E6%88%90%E4%B8%BA%E9%9D%A2%E5%90%91%E5%A4%96%E9%83%A8%E5%AE%A2%E6%88%B7%E7%9A%84%E7%BE%8E%E5%9B%A2%E4%BA%A7%E5%93%81%E3%80%82%E5%9B%A0%E6%AD%A4%EF%BC%8CPtubes%20%E9%A1%B9%E7%9B%AE%E5%B9%B6%E4%B8%8D%E5%AF%BB%E6%B1%82%E5%B0%86%20Apache%20%E5%93%81%E7%89%8C%E7%94%A8%E4%BD%9C%E8%90%A5%E9%94%80%E5%B7%A5%E5%85%B7%E3%80%82%0A%0APtubes%20proposes%20to%20enter%20the%20Apache%20incubator%2C%20hoping%20to%20attract%20more%20diverse%20submitters%20to%20participate%20and%20achieve%20the%20purpose%20of%20enriching%20the%20product%20form%2C%20rather%20than%20using%20the%20Apache%20brand%20for%20commercial%20purposes.%20The%20Ptubes%20project%20has%20been%20widely%20used%20in%20the%20Meituan%20production%20environment%2C%20but%20will%20not%20be%20a%20Meituan%20product%20for%20external%20customers.%20Therefore%2C%20the%20Ptubes%20project%20does%20not%20seek%20to%20use%20the%20Apache%20brand%20as%20a%20marketing%20tool.%0A%0A%0A%23%23%20Documentation%0AInformation%20about%20Ptubes%20can%20be%20found%20on%20the%20Github%20project%20wiki%20%5Bhttps%3A%2F%2Fgithub.com%2Fmeituan%2Fptubes%2Fwiki%5D%0A%0A%23%23%20Initial%20Source%0APtubes%20has%20been%20under%20development%20at%20Meituan%20since%202015.%20The%20source%20code%20was%20opened%20up%20in%202022.%20It%20is%20currently%20hosted%20on%20Github%20using%20the%20Apache%20License%20(%5Bhttps%3A%2F%2Fgithub.com%2Fmeituan%2Fptubes%2Fblob%2Fmaster%2FLICENSE%5D).%0A%0A%23%23%20Source%20and%20Intellectual%20Property%20Submission%20Plan%0A%E7%9B%AE%E5%89%8D%E4%BB%A3%E7%A0%81%E6%98%AF%20Apache%202.0%20%E8%AE%B8%E5%8F%AF%E7%9A%84%EF%BC%8C%E7%89%88%E6%9D%83%E5%BD%92%E7%BE%8E%E5%9B%A2%E6%89%80%E6%9C%89%E3%80%82%E5%A6%82%E6%9E%9C%E9%A1%B9%E7%9B%AE%E8%BF%9B%E5%85%A5%E5%AD%B5%E5%8C%96%E5%99%A8%EF%BC%8C%E7%BE%8E%E5%9B%A2%E5%B0%86%E9%80%9A%E8%BF%87%E8%BD%AF%E4%BB%B6%E6%8E%88%E6%9D%83%E5%8D%8F%E8%AE%AE%E5%B0%86%E6%BA%90%E4%BB%A3%E7%A0%81%E5%92%8C%E5%95%86%E6%A0%87%E6%89%80%E6%9C%89%E6%9D%83%E8%BD%AC%E8%AE%A9%E7%BB%99%20ASF%E3%80%82%0A%0AThe%20current%20code%20is%20licensed%20under%20Apache%202.0%2C%20and%20the%20copyright%20belongs%20to%20Meituan.%20If%20the%20project%20enters%20the%20incubator%2C%20Meituan%20will%20transfer%20the%20source%20code%20and%20trademark%20ownership%20to%20ASF%20through%20a%20software%20license%20agreement.%0A%0A%0A%23%23%20External%20Dependencies%0APtubes%20depends%20on%20some%20Apache%20projects%3A%0A\*%20commons%0A\*%20helix%0A\*%20zookeeper%0A\*%20Maven%0A%0Aand%20other%20open%20source%20projects%20(organized%20by%20license)%3A%0AALv2%EF%BC%9A%0A\*%20com.101tec%3Azkclient%0A\*%20jackson%0A\*%20guava%0A\*%20protobuf%0A\*%20grpc%0A\*%20fastjson%0A\*%20log4j%0A\*%20apache.httpcomponents%0A\*%20com.lmax.disruptor%0A\*%20io.netty%0A\*%20org.apache.avro%0A\*%20codehaus.groovy%0A%0AEPL%EF%BC%9A%0A\*%20junit%0A\*%20logback%0A\*%20com.vividsolutions%0A%0AMIT%EF%BC%9A%0A\*%20slf4j%0A%0AAs%20all%20dependencies%20are%20managed%20using%20Apache%20Maven%2C%20none%20of%20the%20external%20libraries%20need%20to%20be%20packaged%20in%20a%20source%20distribution.%0A%0A%23%23%20Required%20Resources%0A%23%23%23%20Mailing%20lists%0A%E6%9A%82%E6%97%A0%0A%0A%23%23%23%20Git%20Repositories%0AGit%20is%20the%20preferred%20source%20control%20management%20system%3A%20https%3A%2F%2Fgithub.com%2Fmeituan%2Fptubes%0A%0A%0A%23%23%23%20Issue%20Tracking%0AThe%20community%20would%20like%20to%20continue%20using%20GitHub%20Issues%20(will%20be%20moved%20togithub.com%2Fapache).%0A%0A%23%23%23%20Other%20Resources%0A%E7%A4%BE%E5%8C%BA%E5%B7%B2%E7%BB%8F%E9%80%89%E6%8B%A9%E4%BA%86%20GitHub%E7%A4%BE%E5%8C%BA%20%E4%BD%9C%E4%B8%BA%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90%E5%B7%A5%E5%85%B7%E3%80%82%20%0A%0A%E7%A4%BE%E5%8C%BA%E5%B7%B2%E7%BB%8F%E4%BD%BF%E7%94%A8%20mvn%20%E4%BD%9C%E4%B8%BA%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%8C%85%E5%8F%91%E5%B8%83%E5%B9%B3%E5%8F%B0%E3%80%82%20%0A%0A\*%20We%20has%20chosen%20GitHub%20Community%20as%20the%20continuous%20integration%20tool.%0A%0A\*%20We%20has%20used%20mvn%20as%20a%20platform%20for%20binary%20package%20distribution.%0A%0A%0A%23%23%20Initial%20Committers%0A%0A\*%20Songshu%20Zhang%20%3Czsongshu%40gmail.com%3E%0A\*%20Fei%20Lv%20%3Clfei02758%40gmail.com%3E%0A\*%20Yang%20Yang%20%3Cyangyangksl%40gmail.com%3E%0A\*%20Shance%20Wang%20%3Cwangshance%40gmail.com%3E%0A\*%20Hui%20Wang%20%3Cwangfancying%40gmail.com%3E%0A\*%20Hao%20Kong%20%3Cq422243639%40gmail.com%3E%0A\*%20Kai%20Li%20%3Ckayaklee%3E%0A%0A%23%23%20Affiliations%0A\*%20Songshu%20Zhang%20%3A%20Meituan%0A\*%20Fei%20Lv%20%3A%20Meituan%0A\*%20Yang%20Yang%20%3A%20Meituan%0A\*%20Shance%20Wang%20%3A%20Meituan%0A\*%20Hui%20Wang%20%3A%20Meituan%0A\*%20Hao%20Kong%20%3A%20Meituan%0A\*%20Kai%20Li%20%3A%20Meituan%0A%0A%23%23%20Sponsors%0A%23%23%23%20Champion%0A%E6%BD%98%E5%A8%9F%0A%0A%23%23%23%20Nominated%20Mentors%0A%E5%90%B4%E6%99%9F%0A%0A%E7%8E%8B%E5%B0%8F%E7%91%9E%0A%0A%E5%BC%A0%E4%BA%AE%0A%0A%E8%B4%BA%E5%B0%8F%E6%A1%A5%0A%0A%0A%0A%23%23%23%20Sponsoring%20Entity%0A%E6%88%91%E4%BB%AC%E6%9C%9F%E5%BE%85%20Apache%20%E5%AD%B5%E5%8C%96%E5%99%A8%E8%83%BD%E5%A4%9F%E8%B5%9E%E5%8A%A9%E8%BF%99%E4%B8%AA%E9%A1%B9%E7%9B%AE%E3%80%82%0A%0A%0A%0A%0A1%E3%80%81%E5%BC%80%E5%8F%91%E8%80%85%0A2%E3%80%81%E5%85%B3%E7%B3%BB

    Created at: 2022-04-18T16:56:05+08:00
    Updated at: 2022-07-14T14:59:30+08:00

