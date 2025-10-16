# 🚀 AI Coding Agents Docker Container

一个集成了 8 个 AI 编程智能体的完整 Docker 容器，支持本地离线运行和云端 API 集成。

![Docker](https://img.shields.io/badge/Docker-27.5.1%2B-blue)
![Node](https://img.shields.io/badge/Node-20-green)
![Python](https://img.shields.io/badge/Python-3.x-blue)

## ✨ **快速开始**

### 1️⃣ 命令行
```shell script
# 启容器
$ docker run -it --rm   -v $(pwd)/config.toml:/home/coder/.codex/config.toml   -v $(pwd)/config:/home/coder/.config/ai-tools  \
 --privileged   -e HTTP_PROXY=http://192.168.99.1:7890   -e HTTPS_PROXY=http://192.168.99.1:7890   -e http_proxy=http://192.168.99.1:7890   \
 -e https_proxy=http://192.168.99.1:7890   -e NO_PROXY=localhost,127.0.0.1,www.chatopens.net   -e no_proxy=localhost,127.0.0.1,www.chatopens.net   \
 jdcloudiaas/turta:coder

# 参考 https://www.chatopens.net/codex 配置
$ codex

```

### 2️⃣ 简单配置 

```yaml 
model = "gpt-5-codex"
model_provider = "mirror"

[model_providers.mirror]
name = "mirror"
base_url = "https://www.chatopens.net/codex"
wire_api = "responses"
requires_openai_auth = true
```

## ✨ **核心特性**

- ✅ **8 个 AI 编程工具** - 一站式集成
- ✅ **本地运行** - 支持离线使用和本地 API 集成
- ✅ **Docker 容器** - 开箱即用，无需复杂配置
- ✅ **多 API 支持** - OpenAI、Anthropic、Google、GitHub、Sourcegraph
- ✅ **持久化存储** - 项目文件和配置持久化
- ✅ **自动配置加载** - 环境变量自动注入

---

## 📦 **支持的 AI 编程工具**

### npm-based CLI Tools（5 个）

| 工具 | 命令 | 供应商 | 功能描述 |
|------|------|--------|---------|
| **Anthropic Claude** | `claude` | Anthropic | 高级代码生成和分析 |
| **Continue** | `cn` | Continue | IDE 集成的 AI 编程助手 |
| **Sourcegraph Cody** | `cody` | Sourcegraph | 代码智能和补全 |
| **GitHub Copilot** | `github-copilot` | GitHub | GitHub 的 AI 编程助手 |
| **OpenAI Codex** | `codex` | OpenAI | 本地运行的编程智能体 |

### Python-based Tools（3 个）

| 工具 | 命令 | 供应商 | 功能描述 |
|------|------|--------|---------|
| **GPT Engineer** | `gpt-engineer` | OpenAI | 项目级代码生成框架 |
| **Aider** | `aider` | Aider | 交互式 AI 编程对话 |
| **Open Interpreter** | `interpreter` | OpenAI | 代码执行和分析引擎 |

**总计：8 个 AI 编程工具**

---

## 🚀 **快速开始**

### 1️⃣ 克隆或创建项目

```bash
# 创建项目目录
mkdir ai-coding-agents && cd ai-coding-agents

# 创建必需的目录和文件
mkdir -p projects config

# 复制本项目的所有文件到此目录
# Dockerfile
# docker-compose.yml
# .dockerignore
# config/config.env.example
````

### 2️⃣ 构建 Docker 镜像

```bash
# 方式一：使用 docker-compose（推荐）
docker-compose build

# 方式二：直接使用 docker
docker build . -t jdcloudiaas/turta:coder
```

### 3️⃣ 配置 API 密钥

```bash
# 复制配置模板
cp config/config.env.example config/config.env

# 编辑配置文件，填入你的 API 密钥
vim config/config.env
```

**config/config.env 格式：**

```bash
# OpenAI
OPENAI_API_KEY="sk-proj-your-key"
OPENAI_ORG_ID="org-your-org-id"

# Anthropic
ANTHROPIC_API_KEY="sk-ant-your-key"

# Google
GEMINI_API_KEY="your-gemini-key"

# GitHub
GITHUB_TOKEN="ghp_your-token"

# Sourcegraph
SRC_ACCESS_TOKEN="sgp_your-token"
```

### 4️⃣ 启动容器

```bash
# 使用 docker-compose
docker-compose up -it

# 或直接使用 docker
docker run -it --rm \
  -v $(pwd)/projects:/home/coder/projects \
  -v $(pwd)/config:/home/coder/.config/ai-tools \
  jdcloudiaas/turta:coder
```

### 5️⃣ 在容器内使用工具

```bash
# 进入容器后，查看已安装工具
~/list-agents.sh

# 进入项目目录
cd ~/projects

# 使用各种 AI 工具
claude                              # Claude Code
aider --model gpt-4                 # Aider with GPT-4
codex                               # OpenAI Codex
gpt-engineer my-project             # Generate project
interpreter                         # Open Interpreter
```

---

## 📋 **详细使用指南**

### 使用 Aider（推荐入门）

```bash
cd ~/projects

# 创建新项目
mkdir my-app && cd my-app

# 启动 Aider
aider --model gpt-4

# 在 Aider 中输入需求
# /ask 询问问题
# /code 生成代码
# /test 生成测试
```

### 使用 Claude Code

```bash
cd ~/projects

# 启动 Claude
claude

# 按照提示进行交互
# 支持代码生成、分析、重构等
```

### 使用 OpenAI Codex

```bash
cd ~/projects

# 启动 Codex
codex

# 创建本地项目
# Codex 会在本地运行代码分析
```

### 使用 Open Interpreter

```bash
cd ~/projects

# 启动 Interpreter
interpreter

# 执行代码
# >>> import pandas as pd
# >>> df = pd.read_csv("data.csv")
```

### 使用 GPT Engineer

```bash
cd ~/projects

# 生成完整项目
gpt-engineer my-new-project
# 按照提示填写项目需求
```

---

## 🔧 **配置参考**

### Docker Compose 环境变量

```yaml
environment:
  - OPENAI_API_KEY=${OPENAI_API_KEY}        # OpenAI API 密钥
  - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}  # Anthropic API 密钥
  - GEMINI_API_KEY=${GEMINI_API_KEY}        # Google Gemini API 密钥
  - GITHUB_TOKEN=${GITHUB_TOKEN}             # GitHub 令牌
  - SRC_ACCESS_TOKEN=${SRC_ACCESS_TOKEN}    # Sourcegraph 令牌
```

### 持久化卷

| 卷          | 用途   | 路径                             |
| ---------- | ---- | ------------------------------ |
| `projects` | 项目文件 | `/home/coder/projects`         |
| `config`   | 配置文件 | `/home/coder/.config/ai-tools` |
| `cache`    | 缓存数据 | `/home/coder/.cache`           |

---

## 🎯 **常见场景**

### 场景 1：本地快速开发

```bash
# 启动容器
docker-compose up -d

# 在本地编辑文件
vim projects/my-script.py

# 在容器内测试
docker-compose exec ai-coding-agents aider -f projects/my-script.py
```

### 场景 2：生成完整项目

```bash
docker-compose up -it

# 在容器内
cd ~/projects
gpt-engineer my-project
# 填写项目需求，自动生成完整项目
```

### 场景 3：代码分析和优化

```bash
docker-compose up -it

# 在容器内
cd ~/projects
aider --message "优化这个脚本的性能" my-script.py
```

### 场景 4：多工具协作

```bash
# 终端 1：启动 Aider
docker-compose exec ai-coding-agents aider

# 终端 2：使用 Claude
docker-compose exec ai-coding-agents claude

# 终端 3：使用 Codex
docker-compose exec ai-coding-agents codex
```

---

## 🐛 **故障排除**

### 问题 1：构建失败 - "heredoc not supported"

**原因**：Docker 版本过旧或未启用 BuildKit

**解决方案**：

```bash
# 临时启用 BuildKit
DOCKER_BUILDKIT=1 docker build . -t jdcloudiaas/turta:coder

# 或永久启用
echo '{"features": {"buildkit": true}}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker
```

### 问题 2：API 密钥未被加载

**原因**：配置文件不存在或路径错误

**解决方案**：

```bash
# 检查配置文件
ls -la config/config.env

# 验证配置是否加载
docker-compose exec ai-coding-agents env | grep OPENAI
```

### 问题 3：工具命令不存在

**原因**：npm/Python 包安装失败

**解决方案**：

```bash
# 检查已安装的 npm 包
docker-compose exec ai-coding-agents npm list -g

# 检查 Python 工具
docker-compose exec ai-coding-agents pipx list
```

### 问题 4：磁盘空间不足

**原因**：容器镜像和缓存占用空间大

**解决方案**：

```bash
# 清理 Docker 缓存
docker system prune -a

# 检查卷大小
docker volume ls
docker volume inspect ai-coding-agents_ai-tools-cache
```

---

## 📊 **系统需求**

| 要求     | 最低配置              | 推荐配置    |
| ------ | ----------------- | ------- |
| CPU    | 2 核               | 4 核+    |
| 内存     | 4 GB              | 8 GB+   |
| 磁盘     | 10 GB             | 20 GB+  |
| Docker | 24.0.0+           | 27.0.0+ |
| OS     | Linux/Mac/Windows | Linux   |

---

## 📚 **相关链接**

* [Anthropic Claude](https://github.com/anthropics/anthropic-sdk-python)
* [Continue](https://github.com/continuedev/continue)
* [Sourcegraph Cody](https://github.com/sourcegraph/cody)
* [GitHub Copilot](https://github.com/github/copilot-cli)
* [OpenAI Codex](https://github.com/openai/codex)
* [GPT Engineer](https://github.com/AntonOsika/gpt-engineer)
* [Aider](https://github.com/paul-gauthier/aider)
* [Open Interpreter](https://github.com/KillianLucas/open-interpreter)

---

## 📝 **许可证**

此项目使用各工具的开源许可证。具体详见各工具的官方仓库。

---

## 🤝 **贡献**

欢迎提交 Issue 和 Pull Request！

---

## 📞 **支持**

如遇问题，请：

1. 查看 [故障排除](#-故障排除) 部分
2. 检查各工具的官方文档
3. 提交 Issue 或 Discussion

---

**最后更新**：2025-10-16
**版本**：1.0.0