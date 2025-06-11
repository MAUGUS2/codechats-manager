#!/bin/bash

# CodeChats Manager - Quick Installation ✌️
# One line: curl -sSL https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/scripts/quick-install.sh | bash

set -e

# Colors for friendly output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}💬 CodeChats Manager - Quick Installation${NC}"
echo "════════════════════════════════════════════════════════════"

# Check if Claude Code is installed
if [ ! -d "$HOME/.claude" ]; then
    echo -e "${RED}❌ Claude Code not found${NC}"
    echo -e "${YELLOW}Please install Claude Code first:${NC}"
    echo "https://docs.anthropic.com/en/docs/claude-code"
    exit 1
fi

# Check basic dependencies
echo -e "${YELLOW}🔍 Checking dependencies...${NC}"

missing_deps=()
command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
command -v python3 >/dev/null 2>&1 || missing_deps+=("python3")

if [ ${#missing_deps[@]} -ne 0 ]; then
    echo -e "${RED}❌ Missing dependencies: ${missing_deps[*]}${NC}"
    echo
    echo -e "${YELLOW}Install with:${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  brew install ${missing_deps[*]}"
    else
        echo "  sudo apt install ${missing_deps[*]}"
    fi
    exit 1
fi

echo -e "${GREEN}✅ Dependencies OK${NC}"

# Create directories
echo -e "${YELLOW}📂 Creating directories...${NC}"
mkdir -p "$HOME/.claude/temp" "$HOME/.claude/commands"

# Download main files
echo -e "${YELLOW}📥 Downloading CodeChats Manager...${NC}"

# Main script
curl -sSL "https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/src/codechats-main.sh" \
  -o "$HOME/.claude/temp/codechats-main.sh" 2>/dev/null || {
  echo -e "${RED}❌ Error downloading main script${NC}"
  echo "Check your internet connection"
  exit 1
}

# Cache script
curl -sSL "https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/src/codechats-cache.py" \
  -o "$HOME/.claude/temp/codechats-cache.py" 2>/dev/null || {
  echo -e "${RED}❌ Error downloading cache script${NC}"
  exit 1
}

# Make executable
chmod +x "$HOME/.claude/temp/codechats-main.sh"
chmod +x "$HOME/.claude/temp/codechats-cache.py"

# Create global command
echo -e "${YELLOW}🔗 Creating global command...${NC}"
ln -sf "$HOME/.claude/temp/codechats-main.sh" "$HOME/.claude/commands/codechats"

# Configure PATH
echo -e "${YELLOW}🛤️ Configuring PATH...${NC}"
shell_config=""
if [[ "$SHELL" == *"zsh"* ]]; then
    shell_config="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    shell_config="$HOME/.bashrc"
fi

if [ -n "$shell_config" ] && ! grep -q "\.claude/commands" "$shell_config" 2>/dev/null; then
    echo "" >> "$shell_config"
    echo "# CodeChats Manager" >> "$shell_config"
    echo 'export PATH="$HOME/.claude/commands:$PATH"' >> "$shell_config"
    echo -e "${GREEN}✅ PATH configured in $shell_config${NC}"
else
    echo -e "${YELLOW}⚠️ Configure PATH manually:${NC}"
    echo 'export PATH="$HOME/.claude/commands:$PATH"'
fi

# Quick test
echo -e "${YELLOW}🧪 Testing installation...${NC}"
if [ -x "$HOME/.claude/commands/codechats" ]; then
    echo -e "${GREEN}✅ Installation successful!${NC}"
else
    echo -e "${RED}❌ Something went wrong with installation${NC}"
    exit 1
fi

# Final message
echo
echo -e "${GREEN}🎉 CodeChats Manager installed successfully!${NC}"
echo "════════════════════════════════════════════════════════════"
echo
echo -e "${BLUE}📖 How to use:${NC}"
echo "  1. Restart terminal (or run: source ~/.zshrc)"
echo "  2. Type: codechats"
echo "  3. Navigate and enjoy!"
echo
echo -e "${BLUE}📁 Installed files:${NC}"
echo "  ~/.claude/temp/codechats-main.sh"
echo "  ~/.claude/temp/codechats-cache.py"  
echo "  ~/.claude/commands/codechats"
echo
echo -e "${BLUE}🔗 Useful links:${NC}"
echo "  📚 Documentation: https://github.com/MAUGUS2/codechats-manager"
echo "  🐛 Issues: https://github.com/MAUGUS2/codechats-manager/issues"
echo
echo -e "${YELLOW}💡 Try it now: ${GREEN}codechats${NC}"
echo
echo -e "${BLUE}✌️${NC}"