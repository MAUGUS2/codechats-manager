# CodeChats Manager Package

This package contains the complete CodeChats Manager system for Claude Code conversation management.

## Package Contents

### Core Files
- `codechats-main.sh` - Main application script
- `codechats-cache.py` - Cache generation system
- `install.sh` - Installation script

### Documentation
- `README.md` - Main documentation and usage guide
- `CHANGELOG.md` - Version history and changes
- `LICENSE` - MIT license terms
- `docs/ARCHITECTURE.md` - Technical architecture documentation
- `docs/EXAMPLES.md` - Usage examples and workflows
- `docs/CONTRIBUTING.md` - Contribution guidelines
- `docs/TROUBLESHOOTING.md` - Common issues and solutions

### Development
- `scripts/test.sh` - Test runner
- `scripts/dev-setup.sh` - Development environment setup
- `FILES.txt` - Complete file manifest

## Quick Installation

```bash
# Run the installer
./install.sh

# Or manual installation
chmod +x codechats-main.sh
mkdir -p ~/.claude/temp ~/.claude/commands
cp codechats-main.sh ~/.claude/temp/
cp codechats-cache.py ~/.claude/temp/
ln -sf ~/.claude/temp/codechats-main.sh ~/.claude/commands/codechats
echo 'export PATH="$HOME/.claude/commands:$PATH"' >> ~/.zshrc
```

## Package Verification

```bash
# Run tests
./scripts/test.sh

# Verify file integrity
shasum -c FILES.txt
```

Generated: $(date)
Version: 1.0.0
