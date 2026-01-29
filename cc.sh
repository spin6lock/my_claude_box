#!/bin/bash
#docker build -t claude-code .

# 自动加载脚本所在目录的 .env 文件（如果存在）
# 解析软链接，获取脚本真实所在目录
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"

echo "[cc.sh] 脚本目录: $SCRIPT_DIR" >&2
echo "[cc.sh] .env 文件路径: $SCRIPT_DIR/.env" >&2

if [ -f "$SCRIPT_DIR/.env" ]; then
  echo "[cc.sh] 找到 .env 文件，正在加载..." >&2
  set -a
  source "$SCRIPT_DIR/.env"
  set +a
  echo "[cc.sh] .env 加载完成" >&2
  echo "[cc.sh] ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL:-(未设置)}" >&2
  echo "[cc.sh] ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN:+已设置}" >&2
else
  echo "[cc.sh] 未找到 .env 文件" >&2
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
  ghcr.io/spin6lock/my_claude_box:latest "$@"
