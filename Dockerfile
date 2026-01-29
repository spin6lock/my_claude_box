FROM ubuntu:24.04

# 避免交互式安装提示
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 安装基本工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git vim build-essential \
    ca-certificates gnupg lsb-release apt-utils sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 使用官方安装脚本安装 Claude Code CLI
RUN curl -fsSL https://claude.ai/install.sh | bash

# 创建非 root 用户
RUN useradd -m -s /bin/bash claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /workspace && \
    chown -R claude:claude /workspace

USER claude
WORKDIR /workspace

CMD ["claude", "code", "--dangerously-skip-permissions"]
