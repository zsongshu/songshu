# gitlab迁移版本库(保留原版本库的所有内容)

如果你想从别的 Git 托管服务那里复制一份源代码到新的 Git 托管服务器上的话，可以通过以下步骤来操作。
1) 从原地址克隆一份裸版本库，比如原本托管于 GitHub

|     |     |
| --- | --- |
| 1   | git clone --bare git://github.com/username/project.git |

2) 然后到新的 Git 服务器上创建一个新项目，比如 Gitcafe。
3) 以镜像推送的方式上传代码到 GitCafe 服务器上。

|     |     |
| --- | --- |
| 1<br>2 | cd project.git<br>git push --mirror [git@gitcafe.com](mailto:git@gitcafe.com)/username/newproject.git |

4)删除本地代码

|     |     |
| --- | --- |
| 1<br>2 | cd ..<br>rm \-rf project.git |

5).到新服务器 GitCafe 上找到 Clone 地址，直接 Clone 到本地就可以了

|     |     |
| --- | --- |
| 1   | git clone [git@gitcafe.com](mailto:git@gitcafe.com)/username/newproject.git |

这种方式可以保留原版本库中的所有内容。

    Created at: 2019-12-06T17:46:40+08:00
    Updated at: 2019-12-06T17:55:24+08:00

