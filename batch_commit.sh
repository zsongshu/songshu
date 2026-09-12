#!/bin/bash
# 分批提交脚本 - 每批 50MB

cd ~/songshu

MAX_SIZE=52428800  # 50MB in bytes
BATCH_NUM=1
CURRENT_SIZE=0

echo "Total files to commit:"
git status --porcelain | grep "^?? " | grep "attachments/" | wc -l
echo ""
echo "Starting batch commits..."
echo ""

# Process files
git status --porcelain | grep "^?? " | grep "attachments/" | sed 's/^?? //' | sort -t/ -k2 | while read -r FILE; do
    if [[ ! -f "$FILE" ]]; then
        continue
    fi
    
    SIZE=$(stat -f%z "$FILE" 2>/dev/null || stat -c%s "$FILE" 2>/dev/null || echo 0)
    
    # If adding this file would exceed the limit and we have accumulated files
    if [[ $((CURRENT_SIZE + SIZE)) -gt $MAX_SIZE ]] && [[ $CURRENT_SIZE -gt 0 ]]; then
        echo "Batch $BATCH_NUM: $(($BATCH_NUM * 50))MB limit reached, committing..."
        git add attachments/* 2>/dev/null
        git commit -m "chore: add attachments batch $BATCH_NUM" 2>/dev/null
        BATCH_NUM=$((BATCH_NUM + 1))
        CURRENT_SIZE=0
    fi
    
    CURRENT_SIZE=$((CURRENT_SIZE + SIZE))
done

# Commit remaining
if [[ $CURRENT_SIZE -gt 0 ]]; then
    echo "Batch $BATCH_NUM: Committing remaining files"
    git add attachments/* 2>/dev/null
    git commit -m "chore: add attachments batch $BATCH_NUM" 2>/dev/null
fi

echo ""
echo "Done!"
