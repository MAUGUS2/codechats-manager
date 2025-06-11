#!/bin/bash

# Development setup script for CodeChats Manager

echo "🛠️ Setting up development environment..."

# Install development dependencies
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📦 Installing dependencies for macOS..."
    command -v brew >/dev/null 2>&1 || { echo "Please install Homebrew first"; exit 1; }
    brew install jq python3 shellcheck
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "📦 Installing dependencies for Linux..."
    sudo apt-get update
    sudo apt-get install -y jq python3 shellcheck
fi

# Setup pre-commit hooks (if git repo)
if [ -d ".git" ]; then
    echo "🔗 Setting up git hooks..."
    cat > .git/hooks/pre-commit << 'HOOK'
#!/bin/bash
# Run shellcheck on bash scripts
find . -name "*.sh" -exec shellcheck {} \;
# Run Python syntax check
find . -name "*.py" -exec python3 -m py_compile {} \;
HOOK
    chmod +x .git/hooks/pre-commit
fi

echo "✅ Development environment ready!"
echo "📋 Available commands:"
echo "  ./scripts/test.sh - Run tests"
echo "  shellcheck *.sh - Check bash scripts"
echo "  python3 -m py_compile *.py - Check Python scripts"
