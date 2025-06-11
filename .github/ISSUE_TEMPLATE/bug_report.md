---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: 'bug'
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment (please complete the following information):**
 - OS: [e.g. macOS 14.0, Ubuntu 20.04]
 - Shell: [e.g. zsh, bash]
 - Claude Code Version: [e.g. 1.2.3]
 - CodeChats Manager Version: [e.g. 1.0.0]

**Additional context**
Add any other context about the problem here.

**System Information**
```bash
# Please run these commands and paste the output:
echo "OS: $(uname -a)"
echo "Shell: $SHELL"
echo "jq version: $(jq --version)"
echo "Python version: $(python3 --version)"
ls -la ~/.claude/projects/ | head -5
```