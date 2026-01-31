FROM ubuntu:24.04

# 避免交互式安装提示
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
ENV PATH=/root/.local/bin:$PATH

# 安装基本工具和 zsh
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git vim build-essential \
    ca-certificates gnupg lsb-release apt-utils sudo zsh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 使用官方安装脚本安装 Claude Code CLI
RUN curl -fsSL https://claude.ai/install.sh | bash && \
    cp /root/.local/bin/claude /usr/local/bin/claude

# 创建非 root 用户，使用 zsh 作为 shell (UID 1000 以匹配宿主机)
# 先删除默认的 ubuntu 用户 (UID 1000)
RUN userdel -r ubuntu 2>/dev/null || true && \
    useradd -m -u 1000 -s /bin/zsh claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /workspace && \
    chown -R claude:claude /workspace

# 配置 zsh 环境
USER claude
RUN echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc && \
    echo 'export LANG=C.UTF-8' >> ~/.zshrc && \
    echo 'export LC_ALL=C.UTF-8' >> ~/.zshrc && \
    echo 'export TERM=xterm-256color' >> ~/.zshrc

WORKDIR /workspace

CMD ["claude", "code", "--dangerously-skip-permissions"]
