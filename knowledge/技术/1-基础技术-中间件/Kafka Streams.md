# Kafka Streams

Kafka Streams是一个使用Apache Kafka来构造分布式流处理程序的Java库。
虽然只是一个库，但是Kafka Streams直接解决了在流处理中会遇到的很多难题：

* 一次一件事件的处理(而不是microbatch)，延迟在毫秒
* 有状态的处理，包括分布式join和aggregation
* 一个方便的DSL
* 使用类似于DataFlow的模型来处理乱序数据的windowing问题
* 分布式处理，并且有容错机制，可以快速地实现failover
* 有重新处理数据的能力，所以当你的代码更改后，你可以重新计算输出。
* 没有不可用时间的滚动布署。



    Created at: 2019-08-13T22:48:06+08:00
    Updated at: 2025-04-09T14:44:17+08:00

