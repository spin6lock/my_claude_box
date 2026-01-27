FROM ubuntu:20.04

# 避免交互式安装提示 + 设置中文环境（可选）
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 使用阿里云镜像源
RUN sed -i 's|http://archive.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list

# 安装基本工具 + Node.js 18 LTS
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git vim build-essential \
    ca-certificates gnupg lsb-release apt-utils \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 使用 npm 淘宝镜像
RUN npm config set registry https://registry.npmmirror.com

# 安装 Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# 安装 sudo 并创建非 root 用户
RUN apt-get update && apt-get install -y sudo && \
    useradd -m -s /bin/bash claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /workspace && \
    chown -R claude:claude /workspace

USER claude
WORKDIR /workspace

CMD ["claude", "code", "--dangerously-skip-permissions"]

