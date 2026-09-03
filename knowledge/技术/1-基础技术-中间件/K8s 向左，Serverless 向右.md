# K8s 向左，Serverless 向右

原文链接: [https://mp.weixin.qq.com/s?chksm=c321b758f4563e4e9f980c191ba876c...](https://mp.weixin.qq.com/s?chksm=c321b758f4563e4e9f980c191ba876cb1a2cd752e4678efd5271c6ae819e7610f97f0bd535ed&exptype=unsubscribed_card_recommend_article_u2i_mainprocess_coarse_sort_tlfeeds&ranksessionid=1734362875_12&scene=169&mid=2247483776&sn=eb2ed7d159c2b04d2b7431437c7eed19&idx=1&__biz=Mzk0NDY3NzgxNQ==&sessionid=1734362875&subscene=200&clicktime=1734363644&enterid=1734363644&flutter_pos=106&biz_enter_id=5&ascene=56&devicetype=iOS18.2&version=18003634&nettype=WIFI&abtest_cookie=AAACAA==&lang=zh_CN&countrycode=CN&fontScale=140&exportkey=n_ChQIAhIQFF/ucTBgCRsS8hdidR6klhLUAQIE97dBBAEAAAAAAOG0JB19ooEAAAAOpnltbLcz9gKNyK89dVj0rU2e7ONrIX/lJNerVzd01/8RS/GVKdC1Pp5xjbOy614XD+gwBnXfTVnERC2D+OcMyYAv4AiadI/VCn3eYlmeDGP8PkdmbDmKWDtCkc6AbiLU4xK75EPfGsUFON0qWjjAvpGnc42xFQ8sesMbhjPgKifYOJbdV97Ilf1CoaaN+KQj/ZRkBcy4NR/aHkIf1jYxJZVASrxH9lowM7xfTyz4vCZgfC92lwI0P4jaQU69&pass_ticket=iT5ANncU74m/Mo1YpzlxryiSsSsrIC39BJm8Gt73YhnBr8igtdv2tdYyucAbY4yx&wx_header=3)

原创小黄人杂货铺 极客范

# _K8s 向左，Serverless 向右_

_Kubernetes 和 Serverless 无疑是近十年对云计算影响最深刻和广泛的两个技术方向。我在工作的项目中使用了大量 AWS 的 Serverless 服务，包括 Lambda Function、DynamoDB、OpenSearch Serverless，同时前段时间也考取了 K8s 的 Certified Kubernetes Administrator (CKA)。在此过程中，我发现了一个很有意思的现象：K8s 和 Serverless 似乎代表了云原生应用架构中两个相反的技术方向。正因如此，它们各自都有在所探索领域中无可替代的优势，同时也引申出了对应的局限。今天，我们就来梳理一下它们的特点、优劣势，以及在实际项目中的选型建议。当然，如果你对如何准备 CKA 证书感兴趣，也欢迎关注和留言哦！_

---

## _K8s：极致的容器管理_

_Kubernetes 作为容器编排的事实标准，可以用“大而全”来概括， 其核心优势体现在以下几个方面：_

### _**1\. 精细化的资源调度**_

_K8s 提供了对容器运行的全方位控制，无论是 CPU、内存的资源限制，还是节点间的负载均衡，K8s 都能通过配置灵活实现。这对于需要对底层资源有强管控能力的场景非常有价值，比如高性能计算和大规模微服务集群。_

_通过对计算资源的抽象，以pod，service， deployment等抽象单元隐藏底层细节，并用yaml声明来管理资源从而实现对大规模集群的运维管理。_

### _**2\. 强大的生态系统**_

_K8s 拥有一个庞大的开源生态，例如 Helm Charts、Istio、Prometheus 等工具都可以无缝集成到你的集群中。这种强大的扩展能力使得 K8s 成为企业构建复杂云原生架构的核心支柱。_

### _**3\. 跨云和混合云能力**_

_得益于其标准化设计，几乎所有的云厂商都提供了K8s服务，同时k8s也 能够运行在本地数据中心，使得不同云厂商之间的差异进一步缩小， 对于需要避免云厂商锁定的企业来说，K8s 提供了最大的灵活性。_

### _**缺点**_

1. _1. **复杂性高**：K8s 的学习曲线较陡，即使是经验丰富的开发者，也需要投入大量时间进行配置、调试和维护。_
	

		_2. **运维成本高**：K8s 集群需要专业的运维团队来进行监控、升级和优化，尤其是在大规模部署时。_
	
		_3. **不够 Serverless**：虽然 K8s 支持自动扩缩容，但依然需要显式管理底层节点和容器，与 Serverless 的“无服务器”理念背道而驰。_
	

---

## _Serverless：摒弃容器，极致伸缩_

_Serverless 则站在了完全不同的起点上，它的目标是让开发者无需关心底层资源，从而专注于业务逻辑的实现。其核心特点包括：_

### _**1\. 零运维**_

_Serverless 的最大卖点就是将基础设施的运维责任交给服务提供商。开发者不再需要关心服务器、容器甚至操作系统的运行状况，只需专注于代码的开发。这种模式显著降低了开发门槛和运维成本。_

### _**2\. 毫秒级伸缩**_

_Serverless 的按需计费和自动扩缩容能力非常适合负载波动大的应用。例如电商大促、实时数据处理等场景，Serverless 可以毫秒级扩展资源，确保服务稳定运行。_

### _**3\. 极简的部署集成**_

_以 AWS Lambda 为例，你只需要编写函数并上传代码，便可以立即运行，而无需考虑底层的网络配置、存储分配等问题。_

### _**缺点**_

1. _1. **供应商锁定（Vendor Lock-in）**：不同云厂商的 Serverless 平台差异较大，迁移成本高。比如从 AWS Lambda 转移到 Azure Functions 通常需要重写代码以及重写部署，监控等实现。_
	

		_2. **冷启动问题**：由于即用即走请的策略，Serverless 函数在某些情况下可能会有冷启动延迟，影响延迟敏感型应用。_
	
		_3. **有限的配置灵活性**：与 K8s 的强控制能力相比，Serverless 隐藏了底层实现，对运行时的控制粒度取决于云厂商开放的配置项，无法满足复杂场景下的定制需求。_
	
		_4. **架构设计转变**：选择使用serverless并不仅仅是计算平台的转变，同样也要求用不同的侧重点和角度重新审视和改变软件架构，由于冷启动，即用即走的无状等特性，相比于部署在裸机或者容器中的应用，对架构的简洁性，代码体积等都有更高的要求。_
	

---

## _选型建议：如何在 K8s 和 Serverless 之间做选择？_

1. _1. **关注业务需求**：_
	
			_• 如果你的团队需要构建一个复杂的微服务架构，或需要跨云部署，那么 K8s 是一个不错的选择。_
		
			_• 如果你的需求更简单，重点在于快速上线和极简运维，Serverless 则更为合适。_
		
2. _2. **团队技术能力**：_
	
			_• 拥有 DevOps 和 SRE 专业团队的公司可以选择 K8s，以发挥其资源管理的优势。_
		
			_• 小型团队或初创公司更适合 Serverless，以降低技术门槛和维护成本。_
		
3. _3. **成本考虑**：_
	
			_• K8s 的初始投入较高，但对于稳定的大规模系统运行更加经济。_
		
			_• Serverless 的按需计费模式更适合波动性强的业务，但长期高负载场景可能成本偏高。_
		

---

_可以看到，K8s 和 Serverless走上了两条不同的道路，K8s 的复杂性和完善强大功能性对大型复杂集群有必要性的团队至关重要，而 Serverless 的简洁和高效伸缩能力则为快速迭代的业务提供了无可比拟的效率，对于初创企业而言，这将是一个杀手级的优势。如果你也在使用这其中的技术，欢迎留言分享你的心得。_

__

    Created at: 2024-12-16T23:42:03+08:00
    Updated at: 2024-12-16T23:42:03+08:00

