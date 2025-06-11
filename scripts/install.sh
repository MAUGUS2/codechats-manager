#!/bin/bash

# CodeChats Manager Installation Script
# Author: Maugus LCO & Claude Code Community
# Usage: curl -sSL https://raw.githubusercontent.com/your-repo/codechats-manager/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Configuration
GITHUB_REPO="your-repo/codechats-manager"
INSTALL_DIR="$HOME/.claude/temp"
COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_NAME="codechats-main.sh"
CACHE_SCRIPT="codechats-cache.py"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BOLD}${CYAN}💬 CodeChats Manager Installer${NC}"
echo "════════════════════════════════════════════════════════════"
echo -e "${PURPLE}Installing conversation history manager for Claude Code${NC}"
echo

# Function to check if command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}🔍 Checking dependencies...${NC}"
    
    local missing_deps=()
    
    # Check required dependencies
    if ! check_command "bash"; then
        missing_deps+=("bash")
    fi
    
    if ! check_command "jq"; then
        missing_deps+=("jq")
    fi
    
    if ! check_command "python3"; then
        missing_deps+=("python3")
    fi
    
    # Check optional dependencies
    if ! check_command "pbcopy" && ! check_command "xclip"; then
        echo -e "${YELLOW}⚠️  Warning: No clipboard tool found (pbcopy/xclip)${NC}"
        echo -e "${YELLOW}   File path copying will be disabled${NC}"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}❌ Missing required dependencies: ${missing_deps[*]}${NC}"
        echo
        echo -e "${CYAN}Installation instructions:${NC}"
        
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "${GREEN}macOS (Homebrew):${NC}"
            for dep in "${missing_deps[@]}"; do
                case $dep in
                    "jq") echo "  brew install jq" ;;
                    "python3") echo "  brew install python3" ;;
                    "bash") echo "  brew install bash" ;;
                esac
            done
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo -e "${GREEN}Ubuntu/Debian:${NC}"
            echo "  sudo apt-get update"
            for dep in "${missing_deps[@]}"; do
                case $dep in
                    "jq") echo "  sudo apt-get install jq" ;;
                    "python3") echo "  sudo apt-get install python3" ;;
                    "bash") echo "  sudo apt-get install bash" ;;
                esac
            done
            echo
            echo -e "${GREEN}CentOS/RHEL:${NC}"
            for dep in "${missing_deps[@]}"; do
                case $dep in
                    "jq") echo "  sudo yum install jq" ;;
                    "python3") echo "  sudo yum install python3" ;;
                    "bash") echo "  sudo yum install bash" ;;
                esac
            done
        fi
        
        echo
        echo -e "${RED}Please install missing dependencies and run this script again.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ All dependencies satisfied${NC}"
}

# Function to check Claude Code installation
check_claude_code() {
    echo -e "${YELLOW}🔍 Checking Claude Code installation...${NC}"
    
    if [ ! -d "$HOME/.claude" ]; then
        echo -e "${RED}❌ Claude Code not found${NC}"
        echo -e "${YELLOW}Please install Claude Code first:${NC}"
        echo -e "${CYAN}https://docs.anthropic.com/en/docs/claude-code${NC}"
        exit 1
    fi
    
    if [ ! -d "$HOME/.claude/projects" ]; then
        echo -e "${YELLOW}⚠️  No conversation history found${NC}"
        echo -e "${YELLOW}   Run some Claude Code sessions first to create conversation history${NC}"
    else
        local conv_count=$(find "$HOME/.claude/projects" -name "*.jsonl" 2>/dev/null | wc -l)
        echo -e "${GREEN}✅ Found $conv_count conversation files${NC}"
    fi
}

# Function to create directories
create_directories() {
    echo -e "${YELLOW}📂 Creating installation directories...${NC}"
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$COMMANDS_DIR"
    
    echo -e "${GREEN}✅ Directories created${NC}"
}

# Function to download files
download_files() {
    echo -e "${YELLOW}📥 Downloading CodeChats Manager...${NC}"
    
    # For now, we'll use the local files since this is a demo
    # In production, these would be downloaded from GitHub
    
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        echo -e "${CYAN}🔄 Updating existing installation...${NC}"
    fi
    
    # Copy main script from project
    echo -e "${BLUE}📄 Installing main script...${NC}"
    if [ -f "$PROJECT_ROOT/src/$SCRIPT_NAME" ]; then
        cp "$PROJECT_ROOT/src/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
    else
        echo -e "${RED}❌ Source file not found: $PROJECT_ROOT/src/$SCRIPT_NAME${NC}"
        exit 1
    fi
    
    # Copy cache script from project  
    echo -e "${BLUE}📄 Installing cache script...${NC}"
    if [ -f "$PROJECT_ROOT/src/$CACHE_SCRIPT" ]; then
        cp "$PROJECT_ROOT/src/$CACHE_SCRIPT" "$INSTALL_DIR/$CACHE_SCRIPT"
    else
        echo -e "${RED}❌ Cache script not found: $PROJECT_ROOT/src/$CACHE_SCRIPT${NC}"
        exit 1
    fi
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    chmod +x "$INSTALL_DIR/$CACHE_SCRIPT"
    
    echo -e "${GREEN}✅ Files downloaded and configured${NC}"
}

# Function to create command link
create_command() {
    echo -e "${YELLOW}🔗 Creating global command...${NC}"
    
    # Remove existing link if it exists
    if [ -L "$COMMANDS_DIR/codechats" ]; then
        rm "$COMMANDS_DIR/codechats"
    fi
    
    # Create new symlink
    ln -sf "$INSTALL_DIR/$SCRIPT_NAME" "$COMMANDS_DIR/codechats"
    
    echo -e "${GREEN}✅ Command 'codechats' created${NC}"
}

# Function to setup PATH
setup_path() {
    echo -e "${YELLOW}🛤️  Setting up PATH...${NC}"
    
    local shell_config=""
    local current_shell=$(basename "$SHELL")
    
    case $current_shell in
        "zsh")
            shell_config="$HOME/.zshrc"
            ;;
        "bash")
            if [[ "$OSTYPE" == "darwin"* ]]; then
                shell_config="$HOME/.bash_profile"
            else
                shell_config="$HOME/.bashrc"
            fi
            ;;
        "fish")
            shell_config="$HOME/.config/fish/config.fish"
            ;;
        *)
            echo -e "${YELLOW}⚠️  Unknown shell: $current_shell${NC}"
            echo -e "${YELLOW}   Please manually add $COMMANDS_DIR to your PATH${NC}"
            return
            ;;
    esac
    
    # Check if PATH is already configured
    if grep -q "\.claude/commands" "$shell_config" 2>/dev/null; then
        echo -e "${GREEN}✅ PATH already configured${NC}"
        return
    fi
    
    # Add to PATH
    echo "" >> "$shell_config"
    echo "# CodeChats Manager" >> "$shell_config"
    echo 'export PATH="$HOME/.claude/commands:$PATH"' >> "$shell_config"
    
    echo -e "${GREEN}✅ PATH configured in $shell_config${NC}"
    echo -e "${CYAN}💡 Restart your terminal or run: source $shell_config${NC}"
}

# Function to test installation
test_installation() {
    echo -e "${YELLOW}🧪 Testing installation...${NC}"
    
    # Test if script exists and is executable
    if [ -x "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        echo -e "${GREEN}✅ Main script is executable${NC}"
    else
        echo -e "${RED}❌ Main script not found or not executable${NC}"
        exit 1
    fi
    
    # Test if command link works
    if [ -L "$COMMANDS_DIR/codechats" ]; then
        echo -e "${GREEN}✅ Command link created${NC}"
    else
        echo -e "${RED}❌ Command link not found${NC}"
        exit 1
    fi
    
    # Test dependencies
    if command -v jq &> /dev/null && command -v python3 &> /dev/null; then
        echo -e "${GREEN}✅ Dependencies available${NC}"
    else
        echo -e "${RED}❌ Dependencies not available${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Installation test passed${NC}"
}

# Function to show completion message
show_completion() {
    echo
    echo -e "${BOLD}${GREEN}🎉 CodeChats Manager installed successfully!${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    echo -e "${CYAN}📖 Quick Start:${NC}"
    echo "   1. Restart your terminal (or run: source ~/.zshrc)"
    echo "   2. Run: codechats"
    echo
    echo -e "${CYAN}📍 Installation Location:${NC}"
    echo "   Scripts: $INSTALL_DIR"
    echo "   Command: $COMMANDS_DIR/codechats"
    echo
    echo -e "${CYAN}🔗 Documentation:${NC}"
    echo "   https://github.com/$GITHUB_REPO"
    echo
    echo -e "${CYAN}🐛 Support:${NC}"
    echo "   https://github.com/$GITHUB_REPO/issues"
    echo
    echo -e "${YELLOW}💡 Try it now:${NC} ${BOLD}codechats${NC}"
    echo
}

# Main installation flow
main() {
    echo -e "${BLUE}Starting installation...${NC}"
    echo
    
    install_dependencies
    check_claude_code
    create_directories
    download_files
    create_command
    setup_path
    test_installation
    show_completion
}

# Run installation
main "$@"