#!/bin/bash
#docker build -t claude-code .
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
