# LLM/AI

# 吴恩达教你写提示词

**提示工程指南** **Guidelines for Prompting**

* **原则一：写明确和具体的指令**

**策略一：**用分隔符。分隔符可以是任何将特定的文本部分与prompt的其余部分分隔开的符号，比如‘’‘ ’‘’, <>, xml符号等；使用分隔符还可以避免prompt injection（提示词注入）。 
Summarize the text delimited by triple backticks into a single sentence. ‘’’{text}’’’. 
**策略二：**结构化输出。要求模型输出结构化格式，如html或json格式。 
Generate a list of three made-up book titles along with their authors and genres. Provide them in JSON format with the following keys: book\_id, title, author, genre. 
**策略三：**检查条件是否满足。检查需要完成任务的假设是否满足，如果未满足则中止任务。 
You will be provided with text. If it contains a sequence of instructions, re-write those instructions in the following format:  Step 1 - … Step 2 -… Step N -… 
If the text does not contain a sequence of instructions, then simply write “No steps provided.” 
**策略四：**少样本提示。在执行任务之前，提供给模型一些成功执行任务的示例。 
Your task is to answer in a consistent style. <child>: Teach me about patience. <grandparent>: The river that carves the deepest valley flows from a modest spring; the grandest symphony originates from a single note; the most intricate tapestry begins with a solitary thread. <child>: Teach me about resilience. 

* **原则二：给****LLM****时间思考**

重新构建推理链或序列。如果任务过于复杂，模型可能会编造答案（就像人一样）。 
**策略一：**讲清楚完成任务的步骤。 
Perform the following actions: 1 - Summarize the following text delimited by triple backticks with 1 sentence. 2 - Translate the summary into French. 3 - List each name in the French summary. 4 - Output a json object that contains the following keys: french\_summary, num\_names. Separate your answers with line breaks. Text: ‘’’{text}’’’ 
**策略二：**指导模型在匆忙给出结论之前推理出自己的解决方案。 
Your task is to determine if the student’s solution is correct or not. To solve the problem do the following: - First, work out your own solution to the problem. - Then compare your solution to the student’s solution and evaluate if the student’s solution is correct or not. Don’t decide if the student’s solution is correct until you have done the problem yourself. 

* **模型的局限**

**幻觉** **Hallucination****：**给出一些看起来有道理但是实际上是错误的断言。 
Tell me about AeroGlide UltraSlim Smart Toothbrush by Boie 
**降低幻觉的方式：**首先要求模型从源文件中找到相关信息，然后基于相关信息回答问题。 
**🚩****迭代提示开发** **Iterative Prompt Development**
很少有人第一次写Prompt就能取得成功，重要的是在这个过程中不断去迭代你的Prompt迭代步骤：
1. 写出清晰具体、给系统足够时间思考的Prompt
2. 运行并查看结果
3. 分析为什么没有达到预期的结果
4. 修改想法和Prompt并重复以上步骤。 
**不存在一个适用于所有场景的完美****Prompt****！**成为提示工程师的关键不在于知道最完美的Prompt，而在于有一个良好的开发迭代Prompt的流程。 
**🚩****摘要** **Summarizing**
可以告诉模型提取相关信息，而不仅仅是总结。总结电商网站上的用户评论时，如果prompt中强调了”to the shipping department”, 模型总结的摘要的重点会在物流方面的信息上。 
Your task is to extract relevant information from a product review form an ecommerce site to give feed back to the shipping department. 
**🚩****推理** **Inferring**
在传统的NLP任务中，比如情感识别，需要收集数据、训练模型、将模型部署到云端并进行推理，步骤非常的繁琐；而且针对不同的任务需要训练不同的模型。LLM的特点是，针对这些任务，通过写prompt的形式即可马上输出结果，且部署一个模型可输出多个任务。 
What is the sentiment of the following product review, which is delimited with triple backticks? Give your answer as a single word, either “positive” or “negative”. 
零样本学习算法（zero shot learning algorithm）：不提供任何带标签的训练数据，仅通过prompt让模型进行推理。 
🔵注意：文本式的输出方式并不稳定。在生产环境中，让模型输出json格式的output是更为稳定的方式。 
**🚩****转换** **Transforming**

* 不同语言之间的翻译（将英语翻译成西班牙语）
* 不同语气之间的转换（将俚语翻译成商业信函）
* 不同格式之间的转换（将json转译为html格式）
* 校对并改正语法错误

**🚩****扩展** **Expanding**
拓展是将短文本（比如一段摘要）转化为长文本（比如电子邮件），有时会造成一些负面影响，比如有人用这项技术生产垃圾邮件，Andrew呼吁大家在使用的过程中具有社会责任感。 
举例：根据客户评论和识别评论情感，生成回复客户的定制邮件。 
Your are a customer service AI assistant. Your task is to send an email reply to a valued customer. Given the customer email delimited by ‘’’, generate a reply to thank the customer for their review. If the sentiment is positive or neutral, thank them for their review. If the sentiment is negative, apologize and suggest that they can reach out to customer service. Make sure to use specific details from the review. Write in a concise and professional tone. Sign the email as “AI customer agent”. 
温度（temperature）可以改变模型相应的多样性，你可以将温度视为模型的探索性和随机性，温度越低（趋近于0）确定性越强，温度越高（趋近于1）随机性越强。在生产环境下，如果想要构建一个稳定可靠的系统，推荐将温度设为0；如果想让模型输出更加创造性的结果，可以将温度设置的高一些。 
**🚩****聊天机器人** **Chatbot**

* 单一角色与用户对话
* 多角色与用户对话（系统、助手、用户）

系统消息用来设置助手的人设和行为，并作为对话的上层指令，可以视为在助手耳边的悄悄话，而用户无法感知到系统消息。 

* 记住之前对话的内容

每轮对话都是独立的与模型之间的交互，开发者必须提供与当前对话相关的所有信息，供模型调用。如果希望模型从先前的对话中记住信息，必须将之前的对话输入到模型的上下文（context）中。 
**🚩****总结** **Conclusion**

* 两个原则：给出清晰和具体的指令，给模型思考的时间
* 不断迭代你的提示词
* 大模型的能力：摘要、推理、转换、拓展
* 如何构建一个聊天机器人



    Created at: 2024-05-16T09:30:05+08:00
    Updated at: 2024-05-16T09:31:42+08:00

