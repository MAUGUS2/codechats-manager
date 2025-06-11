# Basic Usage Examples

This document provides basic usage examples for CodeChats Manager.

## Installation

```bash
# Quick installation
curl -sSL https://raw.githubusercontent.com/MAUGUS2/codechats-manager/main/scripts/quick-install.sh | bash

# Or clone and install
git clone https://github.com/MAUGUS2/codechats-manager.git
cd codechats-manager
make install
```

## Basic Commands

### Start CodeChats Manager
```bash
codechats
```

### Navigate to project conversations
```bash
# Go to your project directory
cd ~/my-web-app

# Start manager (will show conversations for current project)
codechats
```

### Search for specific topics
```bash
codechats
# Select [4] Search by specific term
# Enter: "authentication"
# Browse results and select conversation
```

### Continue a previous conversation
```bash
# After finding a conversation in CodeChats Manager
# Select the conversation and choose [5] Continue this conversation
# This will copy the command to continue the conversation
continueconversation abc123def456
```

## Workflow Examples

### Daily Development Workflow
```bash
# 1. Start working on a project
cd ~/my-project
claude-code
# Work with Claude Code normally...

# 2. Later, when you need to reference previous work
codechats
# Navigate to find relevant conversations
# Continue where you left off
```

### Debugging Workflow
```bash
# 1. Search for similar error patterns
codechats
# Select [4] Search
# Enter: "error TypeError"
# Review how similar issues were solved

# 2. Continue relevant debugging conversation
# Select conversation and continue
```

### Learning and Reference
```bash
# Find architectural discussions
codechats
# Select [4] Search
# Enter: "architecture"
# Browse past design decisions and patterns
```

## Advanced Usage

### Development Installation
```bash
git clone https://github.com/maugus/codechats-manager.git
cd codechats-manager
make dev-install
```

### Testing Changes
```bash
make test
make lint
```

### Creating Packages
```bash
make package
# Creates distribution in dist/
```

## Tips

1. **Start with current project**: Always run `codechats` from your project directory for best results
2. **Use descriptive search terms**: Try technical terms like "authentication", "deployment", "testing"
3. **Explore by project**: Use option [2] to see all projects you've worked on
4. **Regular review**: Use option [3] to see all recent conversations across projects

---
*by MAUGUS ✌️*