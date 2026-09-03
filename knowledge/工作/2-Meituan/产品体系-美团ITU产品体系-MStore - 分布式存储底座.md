# 产品体系-美团ITU产品体系-MStore - 分布式存储底座



|     |     |
| --- | --- |
| MStore - 分布式存储底座 | 对标阿里盘古，作为对象存储OSS、块存储EBS、文件存储NAS、CPFS、表格存储Tablestore的底座。 |
| Q&A | Q：SDK写ChunkServer的时候，是分别向三个ChunkServer写么？ChunkServer之间感知么？<br> A：三副本之间不感知，由客户端写三副本都成功才返回成功。<br> Q：这里如果2个成功，1个失败，是怎样呢？<br> A：如果有一个写入失败了，就会对当前的三副本做一个seal操作，也就是把这三副本的长度截断到这次失败的写入之前，然后分配一组新的三副本开始写入<br> Q：Blob上限是多大？如果SDK一次需要写入的数据大于Blob上限，是由SDK拆分成多个Blob，还是RootServer拆分呢？ <br> A：blob上限现在限制在2个G。现在用户的一个文件也没有直接映射到一个blob，很多文件会混合在一个blob里面，当一个blob到达2G时就再新建一个blob，文件内容到blob内容的映射有一个索引来维护。映射关系由RootServer维护，也会作为数据存储在chunk server上面。<br> Q：感觉假如SDK和某一台ChunkServer间网络延迟较高，会有一些bad case是吧？写入延迟是最慢的那台<br> A：对的，这种模式的三副本写入延迟抖动的概率会增加，优点是三副本都可以拿来读，因为都保证了是最新数据 |





    Created at: 2024-06-04T09:55:17+08:00
    Updated at: 2024-06-04T09:57:17+08:00

