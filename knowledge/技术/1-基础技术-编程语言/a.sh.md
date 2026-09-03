# a.sh

#!/bin/sh

file=\`find . -name "\*.pdf"\`
for item in $file
do
        echo $item
    /usr/bin/git add $item
    /usr/bin/git commit -m "add $item"
    /usr/bin/git push origin master
done

file=\`find . -name "\*.doc\*"\`
for item in $file
do
        echo $item
        /usr/bin/git add $item
        /usr/bin/git commit -m "add $item"
        /usr/bin/git push origin master
done

file=\`find . -name "\*.ppt\*"\`
for item in $file
do
        echo $item
        /usr/bin/git add $item
        /usr/bin/git commit -m "add $item"
        /usr/bin/git push origin master
done

file=\`find . -name "\*.sh"\`
for item in $file
do
        echo $item
        /usr/bin/git add $item
        /usr/bin/git commit -m "add $item"
        /usr/bin/git push origin master
done


    Created at: 2022-12-28T09:43:44+08:00
    Updated at: 2023-05-16T19:13:29+08:00

