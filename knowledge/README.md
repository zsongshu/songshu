# WorkBuddy 工作记录知识库

本目录是 WorkBuddy 工作产出的**权威源**（md 格式）。

## 归档规则（2026-10-03 用户约定）
- 所有 WorkBuddy 工作记录默认落这里，**不需要用户每次提示**，agent 主动执行。
- **换话题触发总结**：检测到用户从 A 话题切到 B 话题时，立即把 A 话题的对话要点总结成一份 md。
- 分类：按主题建 `topics/<主题>/`；**文件名即表层索引**，格式 `<YYYY-MM-DD>-<类型>-<核心结论或问题>.md`：
  - `<YYYY-MM-DD>`：完整日期，便于排序与判断时效；
  - `<类型>`：一眼区分文件性质——`compare`(对比) / `guide`(操作指引) / `decision`(决策记录) / `summary`(总结) / `note`(笔记/排障) / `faq`；
  - `<核心结论或问题>`：写"这文件能回答什么"，不要重复目录名（目录已给主题）；用英文 slug 保便携（GitHub/URL/跨平台安全），中文留在一句话结论里。
  - 例：`2026-10-03-compare-grok-grokbot-workbuddy-cowork.md`
- 非文本产物仅在确有需要时再建目录存放，此处只引用相对路径，不内联。
- 备份：`git add` + `git commit`（远程 `zsongshu/songshu`）；印象笔记仅作单向可读副本，绝不当唯一源。

## 索引（文件名即索引，下表供不进目录也能速览）
| 文件 | 一句话结论 |
|---|---|
| [topics/ai-product-landscape/2026-10-03-compare-grok-grokbot-workbuddy-cowork.md](topics/ai-product-landscape/2026-10-03-compare-grok-grokbot-workbuddy-cowork.md) | 2026 个人助手形态对比：Grok/Grok Bot 常驻跑腿 vs WorkBuddy/Cowork 工作台产出；含中美四象限、主权 AI、Instinct |
| [topics/ai-service-troubleshooting/2026-10-03-note-llm-api-error-cloudflare-block.md](topics/ai-service-troubleshooting/2026-10-03-note-llm-api-error-cloudflare-block.md) | LLM API 报错与 Cloudflare 封锁的排查记录 |
