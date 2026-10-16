#!/usr/bin/env bash
set -e

echo "🚀 [1/3] 正在生成全站最新内容与构建文件..."
python3 generate_site.py
npx hexo clean
npx hexo generate

echo "📦 [2/3] 正在提交更改并推送到 GitHub..."
git add .
COMMIT_MSG="Site update: $(date '+%Y-%m-%d %H:%M:%S')"
if [ -n "$1" ]; then
  COMMIT_MSG="$1"
fi
git commit -m "$COMMIT_MSG" || echo "当前工作区干净，无需提交新变更。"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
git push origin "$CURRENT_BRANCH"

echo "☁️ [3/3] 正在秒级同步部署到 Cloudflare Pages..."
npx wrangler pages deploy public --project-name tiziwant-blog --branch main

echo ""
echo "🎉 全流程同步完毕！"
echo "  👉 GitHub 仓库: https://github.com/Work050910/tiziwant.blog"
echo "  👉 Cloudflare 网址: https://tiziwant-blog.pages.dev"
