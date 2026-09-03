# 以前画图靠手，现在画图靠吼：我的AI画图“偷懒”指南 🎨

文章摘要：昨天分享了一篇Agent落地的文章，万万没想到，被问到最多是，配图是咋画的？很简单，AI。 如果你也曾为配图掉头发 😭 ，不妨进来看看～

昨天分享了一篇Agent落地的文章，万万没想到，被问到最多是，配图是咋画的？很简单，AI。

如果你也曾为配图掉头发 😭 ，不妨进来看看～

都说“一图胜千言”，但作为技术人，画图这事儿真的挺耗头发 😭

大家都知道，画架构图、流程图，核心就一件事：把脑子里的逻辑倒出来，变成别人能看懂的像素。

不管是自己手搓，还是用 AI，咱们先得把“画给谁看”这事儿想清楚。这就好比写代码前得先搞清楚需求一样，方向不对，画得再花也是白搭。

# 零、过往AI帮我画的一些图

这些图帮我在过往的汇报、PPT、分享中，发挥了巨大作用，希望AI也能帮到你～

|     |     |     |
| --- | --- | --- |
| ![d93a74935536efa49f9b40be4d24bc8a.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/d93a74935536efa49f9b40be4d24bc8a.png) | ![b9d222e1d62292dac7ec23be89c9e7a1.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/b9d222e1d62292dac7ec23be89c9e7a1.png) | ![out?code=fcADqjsPv0MLTfkFuLyP483Pg:-6768188009957624660fcABVf5M7Yv4RoLJGTvb1BrSG:1767702979080](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADqjsPv0MLTfkFuLyP483Pg:-6768188009957624660fcABVf5M7Yv4RoLJGTvb1BrSG:1767702979080) |
| ![f448f181e48d7935874d6ba6f318ea57.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/f448f181e48d7935874d6ba6f318ea57.png) | ![fd506568ccef9d8f71869aa3e886337e.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/fd506568ccef9d8f71869aa3e886337e.png) | ![4810914d55d7d43635711e550a87101b.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/4810914d55d7d43635711e550a87101b.png) |
| ![1831638916a641a49ee9bdb3b11a4519.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/1831638916a641a49ee9bdb3b11a4519.png) | ![c78523cc070f8e57d5e74d9f83f169d8.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/c78523cc070f8e57d5e74d9f83f169d8.png) | ![1550ad112c4848460350d37c70515310.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/1550ad112c4848460350d37c70515310.png) |

# 一、 画图之“道”：看人下菜碟 🧠

很多时候我们觉得图难画，其实是因为没想好这张图的信息密度。

我通常会问自己一个问题：这张图是给老铁看个热闹，还是给兄弟们落地干活用的？

这个问题直接决定了我要怎么画：

## 1\. 调研场景 / PPT 分享：主要看气质

这时候你的受众可能是老板、业务方，或者只有 3 秒钟耐心的听众。

* 目标：传递价值、趋势、全景。人家不关心你的 API 接口长啥样，也没人在意你用的是 MySQL 还是 PostgreSQL。
* 怎么画：
	* 藏细节：不画具体的时序交互，不搞一大堆小字。把那些技术细节通通“折叠”掉，只留核心板块。
	* 重视觉：这时候颜值就是战斗力。多用图标（Icon），多用大色块，甚至搞点动效。
	* 工具：Nanobanana Pro（生图特强）、SVG 动效。

## 2\. 技术评审：细节定成败

这时候你的受众是架构师、开发同事，或者是三个月后再来看代码的你自己

* 目标：落地、对齐。这时候图是用来指导写代码的，模糊一点就是埋雷
* 怎么画：
	* 展细节：同步还是异步？HTTP 还是 RPC？强一致还是最终一致？必须标得清清楚楚
	* 守规矩：不用花里胡哨的配色。流程图、架构图，越标准大家理解成本越低
	* 工具：Mermaid（代码生成，逻辑不错乱）、Draw.io（标准工程图）

所谓画图的“道”，就在于这不仅仅是审美问题，更是你对沟通对象的尊重

# 二、 画图之“术”：AI 辅助的全自动流水线 🤖

既然方向想清楚了，那具体怎么画？如果你还在从零开始拖矩形框，那真的太慢了。现在的画图，早就该升级成 AI 驱动的流水线了

我把这个过程拆解成四个阶段：灵感 -> 草图 -> 编辑 -> 产出

![45d43d4fe2e041a8226692766e1699ad.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/45d43d4fe2e041a8226692766e1699ad.png)

## 1\. 找灵感 💡

📌

用到的工具：processOn、Cursor

不要一上来就打开画布发呆。

* 代码：如果已经有代码了，直接扔给 AI，让它读代码。
	* 可以使用cursor、kwaipilot等
* 文档：有写好的段落文字或者需求文档？复制一段给 AI，让它总结流程。
	* 直接用 doc 的 AI助手就行
* 找参考：实在没思路，去 ProcessOn 搜一下关键词，看看别人怎么画的。大多数时候，你的需求别人早就画过八百遍了。如果是需要数据支撑的图，先用 AI 做个 Deep Research 也不错。

process 模版库：[<u>https://www.processon.com/template</u>](https://www.processon.com/template)

|     |     |
| --- | --- |
| 参考图（[<u>参考图：阶梯</u>](https://www.processon.com/view/64afd0b931c2e55c294a4887)） | 我的图 |
| ![7e6d460778805471c071cfa2014758f7.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/7e6d460778805471c071cfa2014758f7.png) | ![ed9b1aa56884f63bab2069ed288c9a81.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/ed9b1aa56884f63bab2069ed288c9a81.png) |

## 2\. 让 AI 动手：初稿速成 🪄

📌

用到的工具：CherryStudio（预览）、claude模型、nanobanana

经过大量尝试，claude系列模型是画图效果最好的。

这是最爽的一步——从 0 到 1。这里针对不同类型的图，有一套组合拳：

### 流程图战术：AI + 文本/Mermaid

如果是画时序图、状态机这种逻辑线很强的，Mermaid 是唯一真神。也可以直接使用文本线框做快速预览

|     |     |     |
| --- | --- | --- |
| 文本线框：快速预览 | mermaid:分布式SSE技术实现 | mermaid：SOP Agent 架构 |
| ![062a7d7127ccfbbd73a5f87e92b261c7.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/062a7d7127ccfbbd73a5f87e92b261c7.png)![aba3ba29b97b18b1fd66aed8a96637fc.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/aba3ba29b97b18b1fd66aed8a96637fc.png) | ![8184a1263b70e3acb53597532794fec4.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/8184a1263b70e3acb53597532794fec4.png) | ![c44d32ac6f40f13bff4dc57a2bd609e6.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/c44d32ac6f40f13bff4dc57a2bd609e6.png) |

说实话，对于技术实现和链路，我自己也很难梳理得如此细致...

### 架构/示意图战术：AI + SVG / HTML (强烈安利!)

Mermaid 更加适合绘制流程图， 画框框图（架构图）其实挺死板的。这时候我更喜欢让 AI 直接写 SVG/HTML

* 为什么？ 因为现在的 Chatbot（Claude, GPT-4o）都能直接渲染预览。
* 怎么玩？ 你让它生成 SVG，如果不满意（比如颜色不对、模块太挤），直接吼它改。这种“所见即所得”的迭代速度，做 Demo 简直飞快。等效果满意了，再让它把这个 SVG/HTML 转成 Draw.io 的 XML 格式，方便后面去微调。

“嘿，用 SVG 画一个微服务架构图，要有网关、BFF 层和服务层，风格要极简科技风。”  ->  “预览一下，不行，把 BFF 层换成深色”  ->  “OK，转成 XML 给我。”

|     |     |
| --- | --- |
| SVG（矢量、色彩） | HTML（有动效） |
| cherry studio中使用万擎api画图<br><br>![80922a29f7346b532ef0518f35f6e159.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/80922a29f7346b532ef0518f35f6e159.png)![a7af4eb78f8b415894b7e5e80cdc3ddf.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/a7af4eb78f8b415894b7e5e80cdc3ddf.png) | ![out?code=fcADqjsPv0MLTfkFuLyP483Pg:-6768188009957624660fcABVf5M7Yv4RoLJGTvb1BrSG:1767703171822](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADqjsPv0MLTfkFuLyP483Pg:-6768188009957624660fcABVf5M7Yv4RoLJGTvb1BrSG:1767703171822)![out?code=fcADqjsPv0MLTfkFuLyP483Pg:-5828979607764674924fcAA-mbfU4ekkIdHoCTjlryVJ:1767702979082](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADqjsPv0MLTfkFuLyP483Pg:-5828979607764674924fcAA-mbfU4ekkIdHoCTjlryVJ:1767702979082) |

### 氛围图战术：Nanobanana Pro

做 PPT 封面或者概念图，不需要逻辑严密，只需要“感觉对了”。这时候用 Nanobanana Pro 生成那种科技感拉满的示意图，冲击力绝对够。

特别是nanobanana 升级后，对中文的支持也特别好，不会乱码。之前让nanobanana画图只能生成英文的...

|     |     |
| --- | --- |
| ![a246654eb5f5eb24b73ffe3afd5b825e.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/a246654eb5f5eb24b73ffe3afd5b825e.png) | ![d15fc287fa8ac58a10ef6fea31d18c9a.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/d15fc287fa8ac58a10ef6fea31d18c9a.png) |
| ![19e3f70b21daa75a1526185b61901666.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/19e3f70b21daa75a1526185b61901666.png) | ![d19853e2469869028ea24a502ba9eeaa.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/d19853e2469869028ea24a502ba9eeaa.png) |

## 3\. 人工微调：注入灵魂 🎨

📌

用到的工具：Obsidian的excalidraw插件、drawio网页版、[<u>iconfont-阿里巴巴矢量图标库</u>](https://www.iconfont.cn/)、[<u>flaticon（推荐）</u>](https://www.flaticon.com/)

AI 生成的初稿，有时候布局会很丑。这时候就需要咱们人工介入了。我一般走两条路：

### 手绘风：Excalidraw

Q：为什么使用Obsidian中的excalidraw插件？

A：因为excalidraw官网收费，免费版无法管理和存储历史画板

如果你喜欢那种轻松、不那么严肃的风格（像我文章里常用的这种）：

1. 复制 AI 生成的 Mermaid 代码。
2. 打开 Excalidraw，用 Mermaid to Excalidraw 功能粘贴。
3. 润色：手动拖一拖布局，加几个小表情。

![075fbb48b0ff3a1ca94ec12787f71ea9.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/075fbb48b0ff3a1ca94ec12787f71ea9.png)

|     |     |
| --- | --- |
| 草图：AI版 | 微调：人工版（调整内容/配色/布局） |
| ![f00e4076d655f51e5ff4fb9fa3894865.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/f00e4076d655f51e5ff4fb9fa3894865.png) | ![5ffaeb6f12f095b34bb6f78e1ad0c407.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/5ffaeb6f12f095b34bb6f78e1ad0c407.png) |

### 严谨风：Draw.io

Q：为什么使用Draw.io 网页版？[<u>https://app.diagrams.net/#</u>](https://app.diagrams.net/#)

A：快手doc里的画图组件其实也是用的draw.io，<u>但是可能版本过低</u>，把xml粘贴进去，没办法正确渲染。所以使用draw.io网页版，调整好后，可以粘贴回doc

如果你要把图放到比较正式的文档里，或者需要对刚才生成的AI草图做精修：

1. 让 AI 把 SVG/HTML/Mermaid 转成 Draw.io XML。
2. 粘贴到 Draw.io网页版。这时候所有的方块都是可编辑的矢量对象了，调整好后可以全选粘贴回doc的画图组件中。

|     |     |
| --- | --- |
| 草图：AI版 | 微调：人工版（调整内容/配色/布局） |
| ![de917479fbdf44eaacbf8b547f2886e6.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/de917479fbdf44eaacbf8b547f2886e6.png) | ![4503486d24ff401fbc808809f7fcd573.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/4503486d24ff401fbc808809f7fcd573.png) |
| ![3e7def4ec8dcfaf6e60cfdeed5f64b35.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/3e7def4ec8dcfaf6e60cfdeed5f64b35.png) | ![c93aa441738ee2624814e98d6748cbcf.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/c93aa441738ee2624814e98d6748cbcf.png) |

### 💡 独家秘籍：图标大挪移

Excalidraw 和 Draw.io 自带的图标不够用？

* 直接去 Iconfont (阿里巴巴矢量库) 或者 Iconify 找那种精美的 SVG 图标。
* 直接复制 SVG 代码，粘贴到drawio/excalidraw，想要啥 Logo 都有。这招特别管用，瞬间让架构图档次提升几个 Level。

|     |     |
| --- | --- |
| ![59ea414d02ab00ddfd152303d39e4cd6.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/59ea414d02ab00ddfd152303d39e4cd6.png) | ![a5091afa5ec252f6bf601fade9acff86.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/a5091afa5ec252f6bf601fade9acff86.png) |

## 4\. 导出：活起来 📦

📌

用到的工具：chrome capture（浏览器插件）、excalidraw、drawio

* drawio
	* 常规导出即可
* excalidraw

|     |     |
| --- | --- |
| 右上角选择export image<br>![292bf7477517e9114d73954ad31ebf4d.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/292bf7477517e9114d73954ad31ebf4d.png) | 值得一提的是，如果想要图的背景是透明的，导出选项选择Transparent<br><br>![f25a4227ec0e5be7938912bde3282051.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/f25a4227ec0e5be7938912bde3282051.png) |

* 带动效的html
	* 可以使用浏览器插件录制gif导出，我用的是 [<u>chrome-capture-screenshot</u>](https://chromewebstore.google.com/detail/chrome-capture-screenshot/ggaabchcecdbomdcnbahdfddfikjmphe)

# 总结

说到底，画图这事儿没那么玄乎

想清楚给谁看，让 AI 帮你打底稿，自己再去微调润色。

这套流程走下来，省下来的时间，摸会儿鱼～ 🐟

    Created at: 2026-03-31T16:49:24+08:00
    Updated at: 2026-03-31T16:50:59+08:00

