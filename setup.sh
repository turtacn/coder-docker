#!/bin/bash

# 快速设置脚本
set -e

echo "🚀 AI Coding Agents - 快速设置"
echo "================================"

# 创建必需目录
echo "📁 创建目录结构..."
mkdir -p projects config

# 复制配置文件
echo "⚙️  复制配置文件..."
if [ ! -f config/config.env ]; then
    cp config/config.env.example config/config.env
    echo "   ✅ 已创建 config/config.env"
    echo "   ⚠️  请编辑 config/config.env 填入 API 密钥"
else
    echo "   ℹ️  config/config.env 已存在"
fi

# 构建镜像
echo ""
echo "🔨 构建 Docker 镜像..."
DOCKER_BUILDKIT=1 docker-compose build

# 创建 .env 文件用于 docker-compose
echo ""
echo "📝 创建 .env 文件..."
if [ ! -f .env ]; then
    cat > .env << 'EOF'
# Docker Compose 环境变量
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
GEMINI_API_KEY=
GITHUB_TOKEN=
SRC_ACCESS_TOKEN=
EOF
    echo "   ✅ 已创建 .env 文件"
    echo "   ⚠️  请编辑 .env 文件填入 API 密钥"
fi

echo ""
echo "✅ 设置完成！"
echo ""
echo "📋 下一步："
echo "  1. 编辑配置文件："
echo "     vim config/config.env"
echo "     vim .env"
echo ""
echo "  2. 启动容器："
echo "     docker-compose up -it"
echo ""
echo "  3. 在容器内运行工具："
echo "     ~/list-agents.sh"
echo ""