---
title: "他把Claude Code给玩通关了"
source: "他把Claude Code给玩通关了.docx"
type: docx
tags: ["docx"]
path: "777-AI-技术"
created: 2026-07-03
---

# 他把Claude Code给玩通关了

![[他把Claude Code给玩通关了-f7eadb8b.docx]]

## 内容

上个月，Claude Code 的作者 Boris 有篇帖子特别火。

他把内部团队私藏的 13 个 [[AI 编程技巧]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=AI+%E7%BC%96%E7%A8%8B%E6%8A%80%E5%B7%A7&zhida_source=entity)，一股脑全都公开了。

当时我看完就觉得，这哥们真是不拿咱们当外人啊。

我就连夜把全文进行了翻译和润色。

(猛戳回顾👉)[[Claude Code作者私藏13条心法，你就是自己的千军万马]{.underline}](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s/TQ13vs9IPCtEM19k7b2f_Q)

原以为这些干货足够消化一阵儿了，但消停没几天，他又更新了。

![](media/5208bd422b474c880738eae2fc64f495.png){width="8.010416666666666in" height="3.0in"}

如果你觉得上次那点东西已经够硬核了，那我只能说。

咱们，还是太年轻了。

程序员朋友们，你们就放心大胆看完，每一条都值得借鉴。

如果你不是程序员，甚至还没玩过 Claude Code，那你读起来可能会有点吃力。

但别怕，现在可是 AI 时代，哪里不懂直接去问 AI。

千万不要觉得 Claude Code 的命令行界面很可怕。

其实，它只是为了挡住那些不想进步的人。

说真的，现在学习这些知识，比我十多年前学习编程那会儿，可幸福太多了。

全球顶尖的 AI 编程技巧，就这么赤裸裸的摆在你面前，不用你花时间到处去搜索。

真，降维打击。

话不多说，这次一共有 10 条技巧。

下面把时间交给 Boris。

**1、并行多开，效率起飞**

直接起 3 到 5 个 [[git worktree]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=git+worktree&zhida_source=entity)(工作树)，每个里面都独立跑一个 Claude 会话。

**这招绝对是效率提升的核武器，也是团队内部公认的首推技巧。**

说实话，我个人其实习惯搞多个 git checkout（独立文件夹），但团队里大部分人都是死忠的 worktree 党。

这也是为啥 \@amorriscode 特意在 Claude Desktop App 里，给它加了原生支持的原因。

有些哥们还会给 worktree 起个名字，顺手设几个 shell 别名（比如 za，zb，zc 这种）。

这样敲一下键盘，就能在不同任务间反复横跳。

还有人专门留了个分析专用的 worktree，不干别的，专门用来查日志或者跑 [[BigQuery]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=BigQuery&zhida_source=entity)。

![](media/68eb200fdcb73fbf9c7923e5db5f4f9c.png){width="8.010416666666666in" height="3.6875in"}

了解更多：[[https://code]{.underline}](https://code/).[[claude.com/docs/en/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees]{.underline}](http://claude.com/docs/en/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees)

**2、遇事不决先 Plan**

只要碰上复杂的活儿，起手必须先开 [[Plan Mode]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=Plan+Mode&zhida_source=entity)（计划模式）。

**集中你的全部精力，先把计划搞搞细致。**

**这样 Claude 写代码的时候才能一发入魂，直接一遍过。**

有个同事的操作特别骚。

他先让一个 Claude 写计划，然后反手再起一个新的 Claude。

让它扮演资深架构师的角色，专门来审查刚才那个计划靠不靠谱。

还有人分享经验说，一旦发现苗头不对要翻车了，就立刻停手，切回 Plan Mode 重新规划。

千万别头铁，不撞南墙不回头。

而且，计划模式不光是构建的时候能用。

做验收测试的时候，也可以让 Claude 进计划模式。

先盘算好怎么测试，然后再动手干，谋定而后动。

![](media/8b9f76bc5f31737ea79a332f2a937f95.png){width="7.8125in" height="4.197916666666667in"}

**3、把心思花在 [[CLAUDE.md]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=CLAUDE.md&zhida_source=entity) 上**

**一定要重视 [[CLAUDE.md]{.underline}](http://claude.md/) 这个文件。**

每次你纠正完 Claude 的错误，最后都要补一句。

去把 [[CLAUDE.md]{.underline}](http://claude.md/) 更新一下，省得下次再犯同样的错。

说真的，Claude 给自己立规矩这事儿，强得有点邪门。

后续你也要大刀阔斧，毫不留情地去维护这个文件。

不断地迭代打磨，直到你发现 Claude 的犯错率降下来为止。

有个工程师的路子更野。

他让 Claude 给每个任务或项目都专门维护一个笔记目录。

每次提交完代码必须更新笔记。

然后在 [[CLAUDE.md]{.underline}](http://claude.md/) 里直接把路径指过去，这样 Claude 就能随时用到这些笔记了。

![](media/000c1e5c3693c938d519be5942249083.png){width="6.416666666666667in" height="1.8229166666666667in"}

**4、自造技能包**

自己动手写 [[Skill]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=Skill&zhida_source=entity)（技能），然后提交到 Git 仓库里。

这样不管你换哪个项目，都能直接拿来复用。

这里团队给了几个小建议。

第一，拒接重复劳动。

**凡是每天得重复干两次以上的事儿，别犹豫，直接把它封装成一个 Skill 或者指令。**

第二，扫地僧指令。

手搓一个 /techdebt（还技术债）的斜杠指令，每次干完活收工前跑一下，专门用来消灭那些重复的垃圾代码。

第三，一键吸星大法。

搞个指令，一键把 Slack，GDrive，Asana 和 GitHub 最近 7 天的数据全抓下来，打包喂给 Claude 当背景资料。

第四，雇几个 AI 工程师。

搞几个分析工程师风格的 Agent，让它们负责写 dbt 模型，审查代码，甚至直接在开发环境里跑测试。

了解更多：[[https://code.claude.com/docs/en/skills#extend-claude-with-skills]{.underline}](https://link.zhihu.com/?target=https%3A//code.claude.com/docs/en/skills%23extend-claude-with-skills)

**5、Claude 可以搞定大部分 Bug**

先把 Slack MCP 开起来，然后直接把 Slack 上讨论 Bug 的那个帖子甩给 Claude。

告诉它一个字，修。

完全不用切来切去补背景，主打一个无缝衔接。

或者直接跟它说，去把挂掉的 CI 测试修好。

**记住，千万别教它怎么做事，让它自己发挥。**

还有查分布式系统故障的时候，直接把 Docker 日志扔给它看。

你会发现它在这方面强得离谱。

![](media/56c70b9b4e42ec2e913b4e3552fac59d.png){width="8.010416666666666in" height="7.739583333333333in"}

**6、让你的提示词技巧再上一个台阶**

第一，跟 Claude 对线，直接跟它说。

**针对这些改动对我进行严厉质疑和询问，在我通过你的测试之前，不要创建 pull request。**

让 Claude 担任你的代码审查员，或者说。

**给我证明这能跑的通。**

让它去对比主分支和你当前分支的行为差异。

第二，拒绝凑合。

如果他给你的代码只是勉强能用，你直接命令它说。

**基于你现在掌握的所有信息，废弃这个方案，并实现一个最优雅的解决方案。**

第三，需求要写详细。

把活儿甩给它之前，先把要求写清楚，减少不必要的歧义。

你给的指令越具体，它吐出来的东西质量就越高。

**7、终端与环境配置**

我们团队简直是 [[Ghostty 终端]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=Ghostty+%E7%BB%88%E7%AB%AF&zhida_source=entity)的死忠粉。

大家都喜欢它的同步渲染，24 位真彩支持以及完善的 Unicode 支持。

为了更顺手地玩 Claude，推荐你用 /statusline 指令把状态栏调教一下。

让它常驻显示上下文用了多少，以及当前在哪个 Git 分支。

我同事还会给终端的标签页自定义颜色和名字。

有时候配合分屏神器 [[tmux]{.underline}](https://zhida.zhihu.com/search?content_id=269903548&content_type=Article&match_order=1&q=tmux&zhida_source=entity) 一起用，做到一个任务（或一个 Worktree）独占一个 标签页，非常清爽。

还有，我非常推荐使用语音输入。

**你说话的速度比打字快 3 倍，这样你就在不知不觉中把提示词说得特别详细，细节拉满**。（Mac 用户连按两下 fn 键就能唤起）。

![](media/326fde3bf81ed0fde2c8291674b446ea.png){width="8.010416666666666in" height="3.7604166666666665in"}

了解更多：[[https://code]{.underline}](https://code/).[[claude.com/docs/en/terminal-config]{.underline}](http://claude.com/docs/en/terminal-config)

**8、把 Subagents 子智能体用起来**

第一，遇到复杂问题时，可以在提示词后面加一句，use subagents（使用子智能体）。

第二，把具体的独立任务交给 subagents 去干，这样你的主 agent 的上下文窗口才能保持干净和专注。

第三，利用 Hook 钩子功能，把所有的权限申请统统转给 Opus 4.5 去处理。

让智商最高的大模型充当安检员，确认安全的直接放行。

了解更多：[[https://code.claude.com/docs/en/hooks#permissionrequest]{.underline}](https://link.zhihu.com/?target=https%3A//code.claude.com/docs/en/hooks%23permissionrequest)

![](media/011a32203c69a9d4d624a3a196c788e8.png){width="8.010416666666666in" height="6.572916666666667in"}

**9、使用 Claude 进行数据分析**

直接指挥 Claude Code 去调 bq 命令行工具，随时随地拉取数据，进行指标分析。

我们在代码库里，早就预埋好了一个专门的 BigQuery Skill。

现在团队成员们，都是直接在 Claude Code 里进行分析查询。

**说实话，我自己都半年多，没手写过一行 SQL 代码了。**

不管你用啥数据库，只要它带命令行，支持 MCP 或者有 API 接口，统统都能这么玩。

**10、使用 Claude 进行学习**

团队还给了几点使用 Claude 进行学习的建议技巧。

**第一，开启唐僧模式。**

在 /config 中把输出风格改成 Explanatory（解释型）或者 Learning（教学型），这样它能给你解释更改背后的原因。

**第二，PPT 大师。**

碰到不懂的代码，可以直接让 Claude 生成一个可视化的 HTML PPT 来解释，它制作的 PPT 效果出奇地好。

**第三，画图解构。**

让 Claude 给那些新接触的协议或者代码库画个 ASCII 架构图，一图胜千言。

**第四，费曼学习法+艾宾浩斯记忆。**

手搓一个，间隔重复记忆的技能。

玩法是，你先给它讲一遍你的理解。

然后让 Claude 追问你没讲清楚的地方来查漏补缺，最后把这套学习成果存下来。
