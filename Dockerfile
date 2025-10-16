FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV PATH="/home/coder/.local/bin:${PATH}"

WORKDIR /workspace

# Install system dependencies in one layer
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    ca-certificates \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade npm to latest version
RUN npm install -g npm@latest

# Install npm-based AI coding tools
RUN npm install -g \
    @anthropic-ai/claude-code \
    @continuedev/cli \
    @sourcegraph/cody \
    @githubnext/github-copilot-cli \
    @openai/codex \
    && npm cache clean --force

# Create non-root user
RUN useradd -m -s /bin/bash coder

# Switch to user and setup Python tools
USER coder
WORKDIR /home/coder

# Install Python-based tools via pipx
RUN pipx install gpt-engineer && \
    pipx install aider-chat && \
    pipx install open-interpreter

# Create configuration directories
RUN mkdir -p ~/.config/ai-tools ~/.cache ~/projects

# Create configuration template using echo
RUN echo '# AI Tools Configuration Template' > ~/.config/ai-tools/config.env.template && \
    echo '# Copy this file to config.env and fill in your API keys' >> ~/.config/ai-tools/config.env.template && \
    echo '' >> ~/.config/ai-tools/config.env.template && \
    echo '# OpenAI Configuration' >> ~/.config/ai-tools/config.env.template && \
    echo 'OPENAI_API_KEY="your-openai-key-here"' >> ~/.config/ai-tools/config.env.template && \
    echo 'OPENAI_ORG_ID="your-org-id-here"' >> ~/.config/ai-tools/config.env.template && \
    echo '' >> ~/.config/ai-tools/config.env.template && \
    echo '# Anthropic Claude Configuration' >> ~/.config/ai-tools/config.env.template && \
    echo 'ANTHROPIC_API_KEY="your-anthropic-key-here"' >> ~/.config/ai-tools/config.env.template && \
    echo '' >> ~/.config/ai-tools/config.env.template && \
    echo '# Google Gemini Configuration' >> ~/.config/ai-tools/config.env.template && \
    echo 'GEMINI_API_KEY="your-gemini-key-here"' >> ~/.config/ai-tools/config.env.template && \
    echo '' >> ~/.config/ai-tools/config.env.template && \
    echo '# GitHub Copilot Configuration' >> ~/.config/ai-tools/config.env.template && \
    echo 'GITHUB_TOKEN="your-github-token-here"' >> ~/.config/ai-tools/config.env.template && \
    echo '' >> ~/.config/ai-tools/config.env.template && \
    echo '# Sourcegraph Cody Configuration' >> ~/.config/ai-tools/config.env.template && \
    echo 'SRC_ACCESS_TOKEN="your-sourcegraph-token-here"' >> ~/.config/ai-tools/config.env.template && \
    echo 'SRC_ENDPOINT="https://sourcegraph.com"' >> ~/.config/ai-tools/config.env.template

# Create helper script using echo
RUN echo '#!/bin/bash' > ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    echo 'echo "🚀 AI Coding Agents Collection"' >> ~/list-agents.sh && \
    echo 'echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"' >> ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    echo 'echo "📦 Installed Tools:"' >> ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    echo 'echo "  npm-based CLI tools:"' >> ~/list-agents.sh && \
    echo 'echo "    • claude          - Anthropic Claude Code"' >> ~/list-agents.sh && \
    echo 'echo "    • cn              - Continue CLI"' >> ~/list-agents.sh && \
    echo 'echo "    • cody            - Sourcegraph Cody"' >> ~/list-agents.sh && \
    echo 'echo "    • github-copilot  - GitHub Copilot CLI"' >> ~/list-agents.sh && \
    echo 'echo "    • codex           - OpenAI Codex CLI"' >> ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    echo 'echo "  Python tools (via pipx):"' >> ~/list-agents.sh && \
    echo 'echo "    • gpt-engineer    - GPT Engineer"' >> ~/list-agents.sh && \
    echo 'echo "    • aider           - Aider Chat"' >> ~/list-agents.sh && \
    echo 'echo "    • interpreter     - Open Interpreter"' >> ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    echo 'echo "📁 Volume Mounts:"' >> ~/list-agents.sh && \
    echo 'echo "    • ~/projects      - Your project files"' >> ~/list-agents.sh && \
    echo 'echo "    • ~/.config       - Configuration files"' >> ~/list-agents.sh && \
    echo 'echo "    • ~/.cache        - Cache directory"' >> ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    echo 'echo "⚙️  Configuration:"' >> ~/list-agents.sh && \
    echo 'if [ -f ~/.config/ai-tools/config.env ]; then' >> ~/list-agents.sh && \
    echo '    set -a' >> ~/list-agents.sh && \
    echo '    source ~/.config/ai-tools/config.env' >> ~/list-agents.sh && \
    echo '    set +a' >> ~/list-agents.sh && \
    echo '    echo "    ✅ Config loaded from ~/.config/ai-tools/config.env"' >> ~/list-agents.sh && \
    echo '    [ -n "$OPENAI_API_KEY" ] && echo "       ✓ OpenAI API Key"' >> ~/list-agents.sh && \
    echo '    [ -n "$ANTHROPIC_API_KEY" ] && echo "       ✓ Anthropic API Key"' >> ~/list-agents.sh && \
    echo '    [ -n "$GEMINI_API_KEY" ] && echo "       ✓ Gemini API Key"' >> ~/list-agents.sh && \
    echo '    [ -n "$GITHUB_TOKEN" ] && echo "       ✓ GitHub Token"' >> ~/list-agents.sh && \
    echo 'else' >> ~/list-agents.sh && \
    echo '    echo "    ⚠️  No config found"' >> ~/list-agents.sh && \
    echo '    echo "       Copy: ~/.config/ai-tools/config.env.template"' >> ~/list-agents.sh && \
    echo '    echo "       To:   ~/.config/ai-tools/config.env"' >> ~/list-agents.sh && \
    echo 'fi' >> ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    echo 'echo "💡 Quick Start:"' >> ~/list-agents.sh && \
    echo 'echo "    1. cd ~/projects"' >> ~/list-agents.sh && \
    echo 'echo "    2. Run any tool: claude, aider, codex, etc."' >> ~/list-agents.sh && \
    echo 'echo ""' >> ~/list-agents.sh && \
    chmod +x ~/list-agents.sh

# Auto-load config on shell startup
RUN echo '' >> ~/.bashrc && \
    echo '# Auto-load AI tools configuration' >> ~/.bashrc && \
    echo 'if [ -f ~/.config/ai-tools/config.env ]; then' >> ~/.bashrc && \
    echo '    set -a' >> ~/.bashrc && \
    echo '    source ~/.config/ai-tools/config.env' >> ~/.bashrc && \
    echo '    set +a' >> ~/.bashrc && \
    echo 'fi' >> ~/.bashrc

VOLUME ["/home/coder/projects", "/home/coder/.config", "/home/coder/.cache"]

CMD ["/bin/bash", "-c", "~/list-agents.sh && exec /bin/bash"]