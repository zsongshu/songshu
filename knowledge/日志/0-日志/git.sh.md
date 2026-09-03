# git.sh

#!/bin/bash

urls=(

#ssh://git@git.sankuai.com/inf/buffalo-common.git

#ssh://git@git.sankuai.com/inf/buffalo-migration.git

ssh://git@git.sankuai.com/inf/buffalo-reader.git

ssh://git@git.sankuai.com/inf/buffalo-writer.git

#ssh://git@git.sankuai.com/inf/buffalo-ecosystem.git

#ssh://git@git.sankuai.com/inf/dts-sdk.git

)

others=(

)

funGetDir(){

        #echo $1 | awk -F '\[/.:\]' '{print "./"$(NF-2)"/"$(NF-1)}'

        echo $1 | awk -F '\[/.:\]' '{print "./"$(NF-1)}'

}

directories=($(find . -maxdepth 1 -type d))

if \[ "$1" = "clone" \];then

for url in ${urls\[@\]}

do

dirname=\`funGetDir $url\`

        echo "=========================="

echo ">>> " $url ">>> " $dirname

echo \`git clone $url $dirname\`

done

elif \[ "$1" = "pull" \];then

    for dir in "${directories\[@\]}"; do

        # 跳过当前目录（.）和上级目录（..）

        if \[\[ $dir != "." && $dir != ".." \]\]; then

            echo "=========================="

    echo ">>> " $dir

    cur=\`pwd\`

    cd $dir;git pull;cd $cur

        fi

    done

elif \[ "$1" = "view" \];then

    for dir in "${directories\[@\]}"; do

        # 跳过当前目录（.）和上级目录（..）

        if \[\[ $dir != "." && $dir != ".." \]\]; then

            echo "=========================="

    echo ">>> " $dir

    cur=\`pwd\`

    cd $dir;git config --list | grep remote.origin.url;cd $cur

        fi

    done

elif \[ "$1" = "clean" \];then

for url in ${urls\[@\]}

do

dirname=\`funGetDir $url\`

        echo "=========================="

echo ">>> " $url ">>> " $dirname

rm -rf $dirname

done

else

echo $0 "view|clone|pull|clean"

fi

    Created at: 2023-12-01T17:33:58+08:00
    Updated at: 2023-12-01T17:34:09+08:00

