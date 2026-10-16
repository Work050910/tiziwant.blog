#!/usr/bin/env bash
set -e

echo "🚀 [1/3] 正在生成全站最新内容与构建文件..."
python3 generate_site.py
npx hexo clean
npx hexo generate

echo "📦 [2/3] 正在提交更改到本地 Git 仓库..."
git add .
COMMIT_MSG="Site update: $(date '+%Y-%m-%d %H:%M:%S')"
if [ -n "$1" ]; then
  COMMIT_MSG="$1"
fi
git commit -m "$COMMIT_MSG" || echo "当前工作区干净，无需提交新变更。"

echo "☁️ [3/3] 正在推送到 GitHub (将自动触发 Cloudflare Pages 构建发布)..."
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
git push origin "$CURRENT_BRANCH"

echo ""
echo "🎉 推送成功！Cloudflare Pages 正在后台自动拉取代码并全球部署上线！"
