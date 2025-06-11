# 📖 CodeChats Manager Usage Examples

This document provides practical examples and use cases for the CodeChats Manager, helping users understand how to effectively navigate and manage their Claude Code conversation history.

## 🎯 Common Use Cases

### 1. Quick Project Review
**Scenario**: You want to see all conversations related to your current project.

```bash
# Navigate to your project directory
cd ~/projects/my-web-app

# Launch CodeChats Manager
codechats

# Select option 1: Current project CodeChats
[1] 🎯 Current project CodeChats (5 found)
```

**Result**: Shows all conversations for the current project, sorted by recency.

### 2. Cross-Project Search
**Scenario**: You remember discussing authentication but can't remember which project.

```bash
codechats

# Select option 4: Search by specific term
[4] 🔍 Search by specific term

# Enter search term
Enter search term: authentication

# Results show all conversations containing "authentication"
[A] 🔥 [Today 14:30]     System Configuration     (25min, 12 msgs)
    📁 Project: my-web-app
    💬 "Help me implement JWT authentication..."
    🔍 Context: "I need to add JWT authentication to my Express.js API..."
```

### 3. Resume Previous Work
**Scenario**: You want to continue a conversation from yesterday.

```bash
codechats

# Select option 3: View all CodeChats
[3] 🌐 View all CodeChats (23 total)

# Navigate to yesterday's conversation
[B] ⚡ [01-14]     Debug/Testing     (45min, 28 msgs)
    📁 my-api-project
    💬 "The tests are failing with async errors..."

# Select the conversation
Your choice: B

# In conversation detail menu, select continue
[5] 🔄 Continue this conversation
```

**Result**: Copies the continue command to clipboard and provides instructions.

### 4. Project Portfolio Review
**Scenario**: You want to see all projects you've worked on with Claude Code.

```bash
codechats

# Select option 2: Explore other projects
[2] 📁 Explore other projects (6 projects available)

# Shows all projects with conversation history
[A] 🌐 SERVER     (8 CodeChats)
    📍 /Users/maugus/projects/homelab-server
    🕐 Last activity: 🔥 Today 09:15

[B] 🐍 Python     (12 CodeChats)
    📍 /Users/maugus/projects/data-analysis
    🕐 Last activity: ⚡ This week

[C] 📦 my-web-app     (5 CodeChats)
    📍 /Users/maugus/projects/my-web-app
    🕐 Last activity: 📚 2024-01-10
```

## 🎨 Interface Examples

### Main Menu Interface
```
💬 CODECHATS MANAGER
════════════════════════════════════════════════════════════

📍 Current location: /Users/maugus/projects/my-web-app

Choose an option:
[1] 🎯 Current project CodeChats (5 found)
[2] 📁 Explore other projects (6 projects available)
[3] 🌐 View all CodeChats (23 total)
[4] 🔍 Search by specific term
[5] ❌ Exit

Your choice: 
```

### Project Conversation List
```
🎯 PROJECT: /Users/maugus/projects/my-web-app
════════════════════════════════════════════════════════════

📊 5 CodeChats found (sorted by recent):

[A] 🔥 [Today 14:30]     System Configuration     (25min, 12 msgs)
    💬 "Help me implement JWT authentication for my Express.js API..."
    🏷️  Tags: configuration, architecture

[B] ⚡ [01-14]     Debug/Testing     (45min, 28 msgs)
    💬 "The tests are failing with async errors in my React components..."
    🏷️  Tags: debugging, testing

[C] 📚 [2024-01-10]     General CodeChat     (15min, 8 msgs)
    💬 "Can you help me optimize my database queries?"
    🏷️  Tags: architecture

Choose: [A-C] to open | [M] Main menu | [P] Other projects
Your choice: 
```

### Conversation Detail View
```
📖 OPENING CODECHAT: abc123def456
════════════════════════════════════════════════════════════

📁 File: ~/.claude/projects/Users-maugus-projects-my-web-app/abc123def456.jsonl
📊 Statistics:
   💬 Total messages: 12
   🕐 Started: 2024-01-15 14:30:22
   🕐 Ended: 2024-01-15 14:55:18
   ⏱️  Duration: 25 minutes

Choose an action:
[1] 👀 View last 10 messages
[2] 📄 View complete conversation
[3] 🔍 Search term in conversation
[4] 📋 Copy file path
[5] 🔄 Continue this conversation
[B] ⬅️  Go back

Your choice: 
```

### Search Results Interface
```
🔍 SEARCH CODECHATS
════════════════════════════════════════════════════════════

🔍 Searching for: 'database'
════════════════════════════════════════════════════════════

[A] 🔥 [Today 14:30]     System Configuration     (25min, 12 msgs)
    📁 Project: my-web-app
    💬 "Help me implement JWT authentication..."
    🔍 Context: "I need to set up a database connection for authentication..."
    🏷️  Tags: configuration, architecture

[B] 📚 [2024-01-10]     General CodeChat     (15min, 8 msgs)
    📁 Project: my-web-app
    💬 "Can you help me optimize my database queries?"
    🔍 Context: "My database queries are running slowly and I need to optimize..."

[C] ⚡ [01-08]     Architecture Analysis     (60min, 35 msgs)
    📁 Project: data-pipeline
    💬 "Design a scalable database architecture..."
    🔍 Context: "We need to design a database schema that can handle millions..."

Choose: [A-C] to open | [M] Main menu | [N] New search
Your choice: 
```

## 🛠️ Advanced Usage Patterns

### 1. Daily Workflow Integration
**Morning Routine**: Check recent conversations to resume work.

```bash
# Add to your morning routine
codechats_morning() {
    echo "🌅 Daily CodeChats Review"
    codechats
    # Automatically shows today's conversations first
}

# Add to ~/.zshrc or ~/.bashrc
alias morning="codechats_morning"
```

### 2. Project Handoff Documentation
**Scenario**: Documenting conversations for team handoff.

```bash
# Find all conversations for a specific project
codechats

# Navigate to project
[2] 📁 Explore other projects
[A] Select target project

# For each important conversation:
# 1. Copy file path using [4] 📋 Copy file path
# 2. Use external tools to process:

# Extract conversation summary
cat ~/.claude/projects/project-path/session-id.jsonl | \
jq -r 'select(.type == "user") | .message.content' | \
head -5
```

### 3. Learning and Reference
**Scenario**: Finding solutions you discussed before.

```bash
# Search for specific technologies or concepts
codechats

# Use search with technical terms
[4] 🔍 Search by specific term

# Common search terms:
# - "error handling"
# - "performance optimization"
# - "deployment"
# - "testing strategy"
# - "architecture"
```

### 4. Conversation Analytics
**Scenario**: Understanding your coding patterns.

```bash
# View all conversations to see patterns
codechats
[3] 🌐 View all CodeChats

# Observe patterns in:
# - 🔥 Today: Recent active work
# - ⚡ This week: Ongoing projects
# - 📚 Older: Reference conversations

# Look for:
# - Which projects get most attention
# - Common problem areas (debugging tags)
# - Learning progression over time
```

## 🎯 Tips and Tricks

### 1. Efficient Navigation
- **Letter Selection**: Use letters A-Z for quick selection
- **Consistent Patterns**: Main menu always accessible with 'M'
- **Back Navigation**: 'B' consistently goes back one level

### 2. Search Optimization
- **Specific Terms**: Use technical terms for better results
- **Multiple Searches**: Try different keyword combinations
- **Context Clues**: Pay attention to the context snippets shown

### 3. Conversation Management
- **Descriptive First Messages**: Start conversations with clear problem statements
- **Consistent Project Structure**: Keep related work in same directories
- **Regular Reviews**: Periodically review conversation history for insights

### 4. Integration with Other Tools
```bash
# Export conversation for documentation
cat ~/.claude/projects/path/session.jsonl | \
jq -r 'select(.type == "user" or .type == "assistant") | 
       (.timestamp[0:19] + " " + .type + ": " + 
       (.message.content[0].text // .message.content))' > conversation.txt

# Search for specific file mentions
grep -r "filename.js" ~/.claude/projects/ | head -10

# Find conversations with tool usage
grep -r '"tool_calls"' ~/.claude/projects/ | wc -l
```

## 📱 Mobile/Remote Usage

### SSH Access
```bash
# Access CodeChats Manager remotely via SSH
ssh user@remote-machine
codechats

# Works seamlessly over SSH connections
# All functionality preserved including colors and navigation
```

### Screen/Tmux Integration
```bash
# Use with screen or tmux for persistent sessions
tmux new-session -d -s codechats
tmux send-keys -t codechats 'codechats' Enter

# Attach later
tmux attach -t codechats
```

## 🚀 Productivity Workflows

### 1. Debug Session Documentation
```bash
# When starting a debugging session:
# 1. Open CodeChats Manager
# 2. Search for similar past issues
# 3. Reference successful solutions
# 4. Document new session for future reference
```

### 2. Feature Development Planning
```bash
# Before starting new features:
# 1. Search for related architectural discussions
# 2. Review similar implementation patterns
# 3. Continue relevant planning conversations
```

### 3. Code Review Preparation
```bash
# Prepare for code reviews:
# 1. Find conversations about the feature
# 2. Copy important discussion points
# 3. Reference decisions made during development
```

These examples demonstrate the power and flexibility of CodeChats Manager for enhancing your development workflow with Claude Code. The system adapts to various usage patterns and provides consistent, intuitive navigation regardless of your specific needs.