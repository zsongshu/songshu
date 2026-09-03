# 产品体系-美团ITU产品体系-MKE-美团容器集群引擎



|     |     |
| --- | --- |
|  | MKE-美团容器集群引擎<br>    Kubernetes<br>         架构<br>            master<br>                etcd<br>                apiserver<br>                controller manager<br>                scheduler<br>            node<br>                kubelet<br>                Container runtime<br>                kube-proxy<br>            对象属性<br>                核心属性<br>                    metadata<br>                    spec<br>                    status<br>                扩展属性<br>                    labels<br>        集群资源管理<br>            Node<br>            Namespace<br>            Label<br>            Annotation<br>            Taint 和 Toleration（污点和容忍）<br>            垃圾收集<br>            资源调度<br>            服务质量等级（QoS）<br>        控制器<br>            Deployment<br>            StatefulSet<br>            DaemonSet<br>            ReplicationController 和 ReplicaSet<br>            Job<br>            CronJob<br>            Ingress 控制器<br>            Horizontal Pod Autoscaling<br>            准入控制器（Admission Controller）<br>        存储<br>            Secret<br>            ConfigMap<br>            ConfigMap 的热更新<br>            Volume<br>            持久化卷（Persistent Volume）<br>            Storage Class<br>            本地持久化存储<br>        网络<br>            扁平网络 Flannel<br>            非 Overlay 扁平网络 Calico<br>            基于 eBPF 的网络 Cilium<br>        资源对象    <br>            Pod<br>                Pod 概览<br>                Pod 解析<br>                Init 容器<br>                Pause 容器<br>                Pod 安全策略<br>                Pod 的生命周期<br>                Pod Hook<br>                Pod Preset<br>                Pod 中断与 PDB（Pod 中断预算）<br>            ReplicaSet<br>            ReplicationController<br>            Deployment<br>            StatefulSet<br>            DaemonSet<br>            Job<br>            CronJob<br>            HorizontalPodAutoscaling<br>            Node<br>            Namespace<br>            Service<br>            Ingress<br>            Label<br>            CustomResourceDefinition<br>        扩展集群<br>            使用自定义资源扩展 API<br>            使用 CRD 扩展 Kubernetes API<br>            Aggregated API Server<br>            APIService<br>            服务目录（Service Catalog）<br>        存储对象    <br>            Volume<br>            PersistentVolume<br>            Secret<br>            ConfigMap<br>        策略对象    <br>            SecurityContext<br>            ResourceQuota<br>            LimitRange<br>        身份对象    <br>            ServiceAccount<br>            Role<br>            ClusterRole |
|  |  |





    Created at: 2024-06-04T09:58:55+08:00
    Updated at: 2024-06-04T10:01:07+08:00

