#!/bin/bash
# 同步上游仓库脚本

echo "正在从上游仓库获取最新更改..."
git fetch upstream

echo "同步main分支..."
git checkout main
git merge upstream/master --ff-only
git push origin main

echo "同步develop分支..."
git checkout develop  
git merge upstream/develop --ff-only
git push origin develop

echo "同步完成！"
echo "当前分支信息："
git branch -vv