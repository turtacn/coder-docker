.PHONY: help build up down logs shell clean restart

help:
	@echo "🚀 AI Coding Agents - 快速命令"
	@echo "================================"
	@echo "make build       - 构建 Docker 镜像"
	@echo "make up          - 启动容器"
	@echo "make down        - 停止容器"
	@echo "make shell       - 进入容器 shell"
	@echo "make logs        - 查看容器日志"
	@echo "make clean       - 清理容器和卷"
	@echo "make restart     - 重启容器"
	@echo "make setup       - 初始化设置"

build:
	DOCKER_BUILDKIT=1 docker-compose build

up:
	docker-compose up -it

down:
	docker-compose down

shell:
	docker-compose exec ai-coding-agents /bin/bash

logs:
	docker-compose logs -f

clean:
	docker-compose down -v
	docker system prune -a

restart:
	docker-compose restart

setup:
	chmod +x setup.sh
	./setup.sh

# 工具相关命令
claude:
	docker-compose exec ai-coding-agents claude

aider:
	docker-compose exec ai-coding-agents aider

codex:
	docker-compose exec ai-coding-agents codex

gpt-engineer:
	docker-compose exec ai-coding-agents gpt-engineer

interpreter:
	docker-compose exec ai-coding-agents interpreter