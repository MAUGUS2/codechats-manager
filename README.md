# 💬 CodeChats Manager

**A simple tool to navigate and manage your Claude Code conversations visually and intuitively.**

![Demo](https://img.shields.io/badge/demo-working-green.svg) ![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-blue.svg) ![Easy Install](https://img.shields.io/badge/install-one%20command-brightgreen.svg)

## 🎯 What does it do?

Transforms this (hard to navigate):
```
~/.claude/projects/Users-maugus-projects-myapp/abc123.jsonl
~/.claude/projects/Users-maugus-projects-myapp/def456.jsonl
~/.claude/projects/Users-john-work-api/ghi789.jsonl
```

Into this (easy and visual):
```
💬 CODECHATS MANAGER
════════════════════════════════════════════════════════════

📍 Current location: /Users/maugus/projects/myapp

Choose an option:
[1] 🎯 Current project CodeChats (5 found)
[2] 📁 Explore other projects (3 projects available)  
[3] 🌐 View all CodeChats (12 total)
[4] 🔍 Search by specific term
```

## 🚀 Super Simple Installation

### Option 1: One line (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/scripts/quick-install.sh | bash
```

### Option 2: Manual (3 commands)
```bash
git clone https://github.com/MAUGUS2/codechats-manager.git
cd codechats-manager  
./scripts/install.sh
```

### Option 3: Just the essentials
```bash
# Download only the main script
curl -o codechats https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/src/codechats-main.sh
chmod +x codechats
./codechats
```

## 📍 How does it work? (Understand in 2 minutes)

### 🤔 The problem: Claude Code saves everything, but where?

Every time you talk to Claude Code, it **automatically saves** the conversation on your computer:

```bash
# You're working here
/Users/john/my-webapp

# Claude Code saves the conversation here (automatic)
~/.claude/projects/Users-john-my-webapp/abc123def456.jsonl
```

**The file contains the entire conversation:**
```json
{"timestamp": "2024-01-15T10:30:00Z", "type": "user", "message": {"content": "How to create a React button?"}}
{"timestamp": "2024-01-15T10:30:05Z", "type": "assistant", "message": {"content": "I'll help you! Here's..."}}
{"timestamp": "2024-01-15T10:31:00Z", "type": "user", "message": {"content": "And how to add onClick?"}}
```

### 😤 The real problem: How to find your conversations?

**Typical scenario:**
- You talked about authentication last week
- But which project was it? 🤷‍♂️
- In which file? `abc123.jsonl` or `def456.jsonl`? 🤷‍♂️
- How to read JSON files? 😅

**Manual attempt (difficult):**
```bash
find ~/.claude -name "*.jsonl" | xargs grep -l "authentication" | head -5
cat ~/.claude/projects/Users-john-my-webapp/abc123def456.jsonl | jq '...'
```

### ✨ Our solution: Simple visual interface

**With CodeChats Manager:**
```bash
codechats
# Interface appears automatically

[4] 🔍 Search by specific term
> authentication

# Results appear organized:
[A] 🔥 [Today 14:30] Login System (auth, JWT)
    📁 my-webapp
    💬 "How to implement JWT authentication in React?"
```

**Select and continue:**
```bash
[5] 🔄 Continue this conversation
# Opens Claude Code exactly where you left off
```

## 🔍 How Claude Code actually works (transparency)

### File Structure
```bash
~/.claude/projects/
├── Users-john-webapp/           # Your project: /Users/john/webapp  
│   ├── abc123.jsonl            # Conversation 1
│   ├── def456.jsonl            # Conversation 2
│   └── ghi789.jsonl            # Conversation 3
└── Users-john-api/             # Your project: /Users/john/api
    ├── xyz321.jsonl            # Conversation 4
    └── uvw654.jsonl            # Conversation 5
```

### Path Encoding Rules
- Original: `/Users/john/my-webapp` 
- Becomes: `Users-john-my-webapp`
- **Rule**: Replace `/` with `-` and remove special characters

### File Format (JSONL)
- **One line = one message** (user or assistant)
- **Timestamps** in ISO 8601 format
- **Session IDs** are random UUIDs
- **Auto-saved** every interaction

## 💡 Why this tool exists?

**Problem**: Claude Code conversations are **gold mines** of solutions, but finding them is like searching for a needle in a haystack.

**Solution**: CodeChats Manager gives you:
- 🎯 **Smart navigation** by project
- 🔍 **Intelligent search** across all conversations  
- 📊 **Visual organization** with metadata
- 🔄 **Easy continuation** with native Claude Code integration
- ⚡ **Fast access** to your development history

## 🔧 Features

### 🎯 Smart Project Navigation
- Automatically detects your current project
- Shows conversations relevant to your current work
- Browse other projects you've worked on

### 🔍 Intelligent Search
- Search across all conversations by content
- Smart highlighting of search terms
- Quick filtering by technical topics

### 📊 Rich Metadata
- Conversation timestamps and duration
- Message count and activity indicators  
- Auto-categorization (architecture, debugging, etc.)
- Project context and location

### 🔄 Seamless Integration
- Direct integration with Claude Code's `continueconversation` command
- Preserves original conversation files (read-only)
- Works with existing Claude Code workflows

### ⚡ Performance Optimized
- Smart caching (60-minute refresh)
- Handles 100+ conversations efficiently
- Background processing for large datasets
- Instant navigation between cached results

## 🛠️ How to use

### Basic Workflow
1. **Navigate to your project**: `cd ~/my-project`
2. **Launch manager**: `codechats`
3. **Choose what you need**:
   - `[1]` Current project conversations
   - `[2]` Explore other projects
   - `[3]` View all conversations
   - `[4]` Search by term

### Search Examples
```bash
# Technical searches
[4] Search: "authentication"
[4] Search: "deployment" 
[4] Search: "bug fix"
[4] Search: "React hooks"

# Project-specific
[2] Projects → Select → Browse history
```

### Continue Previous Work
```bash
# After finding a conversation
[A] Select conversation
[5] Continue this conversation
# Claude Code opens with full context
```

## 🎉 Benefits

### For Daily Development
- **Save time**: Find solutions you've already discussed
- **Learn patterns**: Review your problem-solving approaches
- **Build knowledge**: Access your personal development database

### For Team Collaboration  
- **Share context**: Show teammates relevant conversations
- **Document decisions**: Conversations become searchable documentation
- **Onboard faster**: New team members can see development history

### For Learning
- **Track progress**: See how your skills develop over time
- **Review techniques**: Revisit successful debugging sessions
- **Build expertise**: Your conversations become a personal knowledge base

## 📋 Requirements

### System Requirements
- **macOS** (Intel/Apple Silicon) or **Linux**
- **Bash** 4.0+ (default on modern systems)
- **Python** 3.6+ (for cache processing)
- **Claude Code** installed and configured

### Optional Dependencies
- `jq` (JSON processing, auto-installed)
- `pbcopy` (macOS) or `xclip` (Linux) for clipboard integration

## 🔧 Advanced Configuration

### Cache Management
```bash
# Cache is automatically refreshed every 60 minutes
# Manual refresh:
~/.claude/temp/codechats-cache.py

# Cache location:
~/.claude/temp/codechats_cache.json
```

### Custom Installation Path
```bash
# Default installation:
~/.claude/temp/codechats-main.sh      # Main script
~/.claude/temp/codechats-cache.py     # Cache generator
~/.claude/commands/codechats          # Global command

# Custom installation:
export CODECHATS_INSTALL_DIR="/custom/path"
./scripts/install.sh
```

## 🐛 Troubleshooting

### Common Issues

**Command not found: `codechats`**
```bash
# Check installation
ls -la ~/.claude/commands/codechats

# Add to PATH manually
export PATH="$PATH:$HOME/.claude/commands"
echo 'export PATH="$PATH:$HOME/.claude/commands"' >> ~/.bashrc
```

**No conversations found**
```bash
# Check Claude Code data directory
ls -la ~/.claude/projects/

# Verify you've had Claude Code conversations
# conversations are auto-saved after each session
```

**Permission denied**
```bash
# Fix permissions
chmod +x ~/.claude/temp/codechats-main.sh
chmod +x ~/.claude/commands/codechats
```

### Getting Help
- 📚 [Documentation](https://github.com/MAUGUS2/codechats-manager/blob/main/docs/)
- 🐛 [Report Issues](https://github.com/MAUGUS2/codechats-manager/issues)
- 💬 [Discussions](https://github.com/MAUGUS2/codechats-manager/discussions)

## 🤝 Contributing

We welcome contributions! See our [Contributing Guide](https://github.com/MAUGUS2/codechats-manager/blob/main/docs/CONTRIBUTING.md) for details.

### Quick Start for Contributors
```bash
git clone https://github.com/MAUGUS2/codechats-manager.git
cd codechats-manager
make dev-setup
make dev-install
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Claude Code Team** - For creating an amazing development tool
- **Open Source Community** - For inspiration and best practices
- **Early Testers** - For feedback and bug reports

---

**CodeChats Manager** makes your Claude Code conversations searchable, accessible, and useful. Transform your development workflow today! ✌️

*by MAUGUS ✌️*