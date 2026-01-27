#!/bin/bash
#docker build -t claude-code .

# 自动加载 .env 文件（如果存在）
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  -v "$(pwd)":/workspace \
  -v "$HOME/.claude":/home/claude/.claude \
  -v "$HOME/.claude/statusline.sh":/home/claude/.claude/statusline.sh:ro \
  -w /workspace \
  -e ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN}" \
  -e ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-https://open.bigmodel.cn/api/anthropic}" \
  -e API_TIMEOUT_MS="3000000" \
  claude-code "$@"
