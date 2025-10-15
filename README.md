# coder-docker
优化这个 Dockerfile,添加 CLI 配置文件管理和外部目录映射支持:

```dockerfile
FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

WORKDIR /workspace

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install all npm-based AI coding tools
RUN npm install -g \
    @openai/codex \
    @google/gemini-cli \
    @anthropic-ai/claude-code \
    @continuedev/cli \
    @sourcegraph/cody \
    @githubnext/github-copilot-cli

# Optional: Install Python-based tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir \
        gpt-engineer \
        aider-chat \
        open-interpreter \
    && pip3 cache purge

# Create non-root user
RUN useradd -m -s /bin/bash coder

# Create configuration directories
RUN mkdir -p /home/coder/.config/ai-tools \
    && mkdir -p /home/coder/projects \
    && mkdir -p /home/coder/.cache \
    && chown -R coder:coder /home/coder

USER coder
WORKDIR /home/coder

# Create default configuration template
RUN echo '# AI Tools Configuration\n\
# Copy this to your host machine and mount as volume\n\
\n\
# OpenAI Configuration\n\
export OPENAI_API_KEY="your-openai-key"\n\
export OPENAI_ORG_ID="your-org-id"\n\
\n\
# Anthropic Claude Configuration\n\
export ANTHROPIC_API_KEY="your-anthropic-key"\n\
\n\
# Google Gemini Configuration\n\
export GEMINI_API_KEY="your-gemini-key"\n\
\n\
# GitHub Copilot Configuration\n\
export GITHUB_TOKEN="your-github-token"\n\
\n\
# Sourcegraph Cody Configuration\n\
export SRC_ACCESS_TOKEN="your-sourcegraph-token"\n\
export SRC_ENDPOINT="https://sourcegraph.com"\n\
' > /home/coder/.config/ai-tools/config.env.template

# Create helper script
RUN echo '#!/bin/bash\n\
echo "🚀 AI Coding Agents Collection"\n\
echo "================================"\n\
echo ""\n\
echo "✅ npm-installed CLI tools:"\n\
echo "  codex           - OpenAI Codex"\n\
echo "  gemini          - Google Gemini CLI"\n\
echo "  claude          - Anthropic Claude Code"\n\
echo "  cn              - Continue CLI"\n\
echo "  cody            - Sourcegraph Cody"\n\
echo "  github-copilot  - GitHub Copilot CLI"\n\
echo ""\n\
echo "🐍 pip-installed tools:"\n\
echo "  gpt-engineer    - GPT Engineer"\n\
echo "  aider           - Aider"\n\
echo "  interpreter     - Open Interpreter"\n\
echo ""\n\
echo "📁 Mounted directories:"\n\
echo "  ~/projects      - Your project files"\n\
echo "  ~/.config       - Configuration files"\n\
echo "  ~/.cache        - Cache directory"\n\
echo ""\n\
echo "📖 Quick start:"\n\
echo "  1. Load config: source ~/.config/ai-tools/config.env"\n\
echo "  2. Run tool:    claude"\n\
echo ""\n\
if [ -f ~/.config/ai-tools/config.env ]; then\n\
    source ~/.config/ai-tools/config.env\n\
    echo "✅ Configuration loaded"\n\
else\n\
    echo "⚠️  No config found. Copy config.env.template to config.env"\n\
fi\n\
' > /home/coder/list-agents.sh && chmod +x /home/coder/list-agents.sh

ENV PATH="/home/coder:${PATH}"

# Set volumes for persistent data
VOLUME ["/home/coder/projects", "/home/coder/.config", "/home/coder/.cache"]

CMD ["/bin/bash", "-c", "/home/coder/list-agents.sh && /bin/bash"]
```

**配套的 docker-compose.yml**:

```yaml
version: '3.8'

services:
  ai-coding-agents:
    build: .
    container_name: ai-coding-tools
    stdin_open: true
    tty: true
    volumes:
      # 项目文件映射
      - ./projects:/home/coder/projects
      
      # 配置文件映射
      - ./config:/home/coder/.config/ai-tools
      
      # 缓存目录映射(可选)
      - ./cache:/home/coder/.cache
      
      # Git 配置映射(可选)
      - ~/.gitconfig:/home/coder/.gitconfig:ro
      
      # SSH 密钥映射(可选,用于 git)
      - ~/.ssh:/home/coder/.ssh:ro
    
    environment:
      # 可以在这里直接设置环境变量,或使用 env_file
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - GEMINI_API_KEY=${GEMINI_API_KEY}
      - GITHUB_TOKEN=${GITHUB_TOKEN}
    
    # 或使用环境变量文件
    # env_file:
    #   - ./config/.env
    
    working_dir: /home/coder/projects
    
    # 网络配置(如果需要访问本地服务)
    # network_mode: host
```

**使用说明文档 (README.md)**:

````markdown
# AI Coding Agents Docker Setup

## 📋 初始设置

### 1. 创建必要的目录结构
```bash
mkdir -p projects config cache
````

### 2. 创建配置文件

复制模板并填写你的 API keys:

```bash
# 从容器中复制模板
docker run --rm ai-coding-tools cat /home/coder/.config/ai-tools/config.env.template > config/config.env

# 编辑配置文件
nano config/config.env
```

或直接创建 `config/config.env`:

```bash
# OpenAI Configuration
export OPENAI_API_KEY="sk-..."
export OPENAI_ORG_ID="org-..."

# Anthropic Claude Configuration
export ANTHROPIC_API_KEY="sk-ant-..."

# Google Gemini Configuration
export GEMINI_API_KEY="..."

# GitHub Copilot Configuration
export GITHUB_TOKEN="ghp_..."

# Sourcegraph Cody Configuration
export SRC_ACCESS_TOKEN="..."
export SRC_ENDPOINT="https://sourcegraph.com"
```

## 🚀 启动容器

### 使用 docker-compose (推荐)

```bash
docker-compose up -d
docker-compose exec ai-coding-agents bash
```

### 使用 docker run

```bash
docker build -t ai-coding-tools .

docker run -it --rm \
  -v $(pwd)/projects:/home/coder/projects \
  -v $(pwd)/config:/home/coder/.config/ai-tools \
  -v $(pwd)/cache:/home/coder/.cache \
  -v ~/.gitconfig:/home/coder/.gitconfig:ro \
  --env-file config/config.env \
  ai-coding-tools
```

## 📁 目录映射说明

| 主机目录           | 容器目录                           | 用途         |
| -------------- | ------------------------------ | ---------- |
| `./projects`   | `/home/coder/projects`         | 你的项目代码     |
| `./config`     | `/home/coder/.config/ai-tools` | CLI 工具配置   |
| `./cache`      | `/home/coder/.cache`           | 缓存数据       |
| `~/.gitconfig` | `/home/coder/.gitconfig`       | Git 配置(只读) |
| `~/.ssh`       | `/home/coder/.ssh`             | SSH 密钥(只读) |

## 💡 使用示例

进入容器后:

```bash
# 加载配置
source ~/.config/ai-tools/config.env

# 使用 Claude Code
cd projects/my-project
claude

# 使用 Aider
aider --model gpt-4

# 使用 GPT Engineer
gpt-engineer projects/new-project

# 使用 Continue
cn chat
```

## 🔒 安全建议

1. **不要提交配置文件**:

   ```bash
   echo "config/config.env" >> .gitignore
   echo ".env" >> .gitignore
   ```

2. **使用环境变量文件** (docker-compose):
   创建 `.env` 文件在项目根目录:

   ```
   OPENAI_API_KEY=sk-...
   ANTHROPIC_API_KEY=sk-ant-...
   ```

3. **限制文件权限**:

   ```bash
   chmod 600 config/config.env
   ```

````

**额外的 .gitignore**:

```gitignore
# 配置文件(包含敏感信息)
config/config.env
config/.env
.env

# 缓存目录
cache/

# 项目文件(根据需要调整)
projects/*
!projects/.gitkeep
````

这个改进版本提供了:

1. ✅ **配置文件管理**: 通过 volume 映射 `.config` 目录
2. ✅ **项目目录映射**: 持久化你的代码
3. ✅ **缓存目录**: 提升性能
4. ✅ **Git 集成**: 映射 gitconfig 和 SSH 密钥
5. ✅ **环境变量支持**: 多种方式配置 API keys
6. ✅ **安全性**: 配置文件不进入镜像,使用 volume 挂载
7. ✅ **易用性**: docker-compose 简化启动流程
