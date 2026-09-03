# Kubernetes Operator

<https://lib.jimmysong.io/kubernetes-handbook/develop/operator/>


[[k8s operator的开发感悟|k8s operator的开发感悟]]

|     |     |
| --- | --- |
| deployment中的replica数量是3，意味着pod的数量必须维持在3，多了，就去除，少了，就创建。由于deployment是k8s内置的资源，k8s本身就有内置的controller来维护deployment的状态。如果自己要创建一个新的逻辑，那么就创建新的CRD和controller，来**创建和维护**对应的deployment，service之类的服务。 | operator实质是指：用户注册自己自定义的Custom Resource Definition，然后创建对应的资源实例（称为Custom Resource，简称CR），而后通过自己编写Controller来不断地检测当前k8s中所定义的CR的状态，如果状态和预期不一致，则调整。Controller具体做的事就是通过调用k8s api server的客户端，根据比较预期的状态和实际的状态，来对相应的资源进行 增，删，改。 |



operator本质上包含两个东西：

1. 创建自定义的CR
2. 编写Controller，调用api server实现对CR的状态的管理





    Created at: 2023-05-23T15:44:48+08:00
    Updated at: 2023-05-23T19:08:55+08:00

