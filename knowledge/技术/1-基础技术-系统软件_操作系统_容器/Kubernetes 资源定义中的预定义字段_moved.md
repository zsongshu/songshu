# Kubernetes 资源定义中的预定义字段

在 Kubernetes 资源清单（YAML/JSON）中，有多个预定义的顶级字段。以下是这些字段的详细解释：

|     |     |     |     |
| --- | --- | --- | --- |
| 字段名 | 是否必需 | 数据类型 | 描述  |
| **apiVersion** | **是** | string | 指定使用的 Kubernetes API 版本，格式为 group/version（如 apps/v1）或核心 API 的 v1 |
| **kind** | **是** | string | 资源类型，如 Pod、Deployment、Service等 |
| **metadata** | **是** | object | 资源的元数据，包含名称、标签、注解等识别信息 |
| **spec** | 大多数资源需要 | object | **期望状态**：描述资源的期望配置和特性 |
| **status** | 只读（系统生成） | object | **实际状态**：由 Kubernetes 系统填充，显示资源的当前状态 |
| **data** | 某些资源特有 | object/map | 用于存储实际数据，主要在 ConfigMap和 Secret中使用 |
| **binaryData** | 某些资源特有 | object/map | 以二进制格式存储数据，主要在 ConfigMap中使用 |
| **stringData** | 某些资源特有 | object/map | 提供字符串格式的数据（自动编码），主要在 Secret中使用 |
| **subsets** | 某些资源特有 | array | 描述端点列表，主要在 Endpoints资源中使用 |

---

## **metadata 字段的详细子字段**

|     |     |     |     |
| --- | --- | --- | --- |
| 字段名 | 是否必需 | 描述  | 示例  |
| **name** | **是** | 资源名称，在命名空间内唯一 | name: my-app |
| **namespace** | 可选  | 资源所属的命名空间 | namespace: production |
| **labels** | 可选  | 键值对标签，用于标识和选择资源 | app: nginx, env: prod |
| **annotations** | 可选  | 非识别性元数据，用于工具和扩展 | description: "生产环境前端" |
| **uid** | 系统生成 | 资源的唯一标识符 |  |
| **resourceVersion** | 系统生成 | 资源的版本号，用于乐观并发控制 |  |
| **generation** | 系统生成 | 表示期望状态的世代数 |  |
| **creationTimestamp** | 系统生成 | 资源创建时间戳 |  |
| **deletionTimestamp** | 系统生成 | 资源删除时间戳（如果正在删除） |  |
| **finalizers** | 可选  | 删除资源前需要完成的清理操作列表 |  |
| **ownerReferences** | 系统生成 | 指向拥有此资源的上级资源 |  |
| **generateName** | 可选  | 生成唯一名称的前缀（替代 name） | generateName: test-pod- |

---

## **spec 字段的常见子字段（因资源类型而异）**

|     |     |     |
| --- | --- | --- |
| 字段名 | 适用资源 | 描述  |
| **containers** | Pod, Deployment, etc | 容器定义列表 |
| **replicas** | Deployment, StatefulSet, etc | 期望的 Pod 副本数量 |
| **selector** | Deployment, Service, etc | 标签选择器，用于识别管理的资源 |
| **template** | Deployment, StatefulSet, etc | Pod 模板定义 |
| **ports** | Service, Pod, etc | 网络端口配置 |
| **type** | Service | 服务类型（ClusterIP, NodePort, LoadBalancer） |
| **rules** | Ingress, NetworkPolicy, etc | 访问规则列表 |
| **resources** | Container | 资源请求和限制（CPU, 内存） |
| **volumes** | Pod | 存储卷定义 |
| **accessModes** | PersistentVolumeClaim | 存储访问模式 |
| **storageClassName** | PersistentVolumeClaim | 存储类名称 |

---

## **status 字段的常见子字段（系统只读）**

|     |     |
| --- | --- |
| 字段名 | 描述  |
| **phase** | 资源当前阶段（如 Pod 的 Pending, Running, Succeeded, Failed） |
| **conditions** | 资源状态条件列表，包含类型、状态、原因、消息等 |
| **message** | 人类可读的状态描述信息 |
| **reason** | 机器可读的状态原因代码 |
| **podIP** | Pod 的 IP 地址 |
| **hostIP** | Pod 所在节点的 IP 地址 |
| **startTime** | Pod 开始运行的时间 |
| **containerStatuses** | 各个容器的详细状态信息 |
| **availableReplicas** | 可用的副本数量（Deployment/StatefulSet） |
| **readyReplicas** | 就绪的副本数量 |
| **currentReplicas** | 当前副本数量 |
| **updatedReplicas** | 已更新到最新版本的副本数量 |
| **loadBalancer** | 负载均衡器信息（Service） |

---

## **完整示例展示各字段用法**

_\# 顶级字段_ apiVersion: apps/v1 _\# API 版本_ kind: Deployment _\# 资源类型_ metadata: _\# 元数据_ name: nginx-deployment labels: app: nginx annotations: [deployment.kubernetes.io/revision](http://deployment.kubernetes.io/revision): "1" spec: _\# 期望状态_ replicas: 3 selector: matchLabels: app: nginx template: metadata: labels: app: nginx spec: containers: - name: nginx image: nginx:1.25 ports: - containerPort: 80 _\# status 字段由系统自动生成，不需要也不应该在清单中定义_

---

## **特殊资源类型的特有字段**

|     |     |     |
| --- | --- | --- |
| 资源类型 | 特有字段 | 描述  |
| **ConfigMap** | data, binaryData | 存储配置数据 |
| **Secret** | data, stringData, type | 存储敏感数据 |
| **ServiceAccount** | secrets | 关联的 Secret 列表 |
| **HorizontalPodAutoscaler** | scaleTargetRef, minReplicas, maxReplicas, metrics | 自动扩缩配置 |
| **PersistentVolume** | capacity, persistentVolumeReclaimPolicy, storageClassName | 存储卷配置 |
| **CustomResourceDefinition** | spec.versions, spec.scope, spec.names | 自定义资源定义 |

这些预定义字段构成了 Kubernetes 资源定义的基础框架，了解它们有助于正确编写和理解 Kubernetes 清单文件。

    Created at: 2025-11-25T15:12:19+08:00
    Updated at: 2025-11-25T15:13:22+08:00

