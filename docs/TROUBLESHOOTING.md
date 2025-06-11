# Troubleshooting Guide

Common issues and solutions for CodeChats Manager.

## Installation Issues

### Command not found: codechats
**Symptoms**: Terminal shows "command not found" when running `codechats`

**Solutions**:
1. Check if PATH includes ~/.claude/commands:
   ```bash
   echo $PATH | grep -o "\.claude/commands"
   ```

2. If not found, add to shell configuration:
   ```bash
   echo 'export PATH="$HOME/.claude/commands:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. Verify symlink exists:
   ```bash
   ls -la ~/.claude/commands/codechats
   ```

### Missing dependencies
**Symptoms**: Script fails with "command not found" for jq or python3

**Solutions**:
- **macOS**: `brew install jq python3`
- **Ubuntu/Debian**: `sudo apt-get install jq python3`
- **CentOS/RHEL**: `sudo yum install jq python3`

## Runtime Issues

### No conversations found
**Symptoms**: "0 CodeChats found" despite having Claude Code history

**Solutions**:
1. Check Claude Code installation:
   ```bash
   ls ~/.claude/projects/
   ```

2. Verify conversation files exist:
   ```bash
   find ~/.claude/projects -name "*.jsonl" | head -5
   ```

3. Check file permissions:
   ```bash
   ls -la ~/.claude/projects/
   ```

### Cache not updating
**Symptoms**: New conversations don't appear in CodeChats Manager

**Solutions**:
1. Force cache refresh:
   ```bash
   rm ~/.claude/temp/codechats_cache.json
   codechats
   ```

2. Check Python script permissions:
   ```bash
   ls -la ~/.claude/temp/codechats-cache.py
   ```

3. Manual cache generation:
   ```bash
   python3 ~/.claude/temp/codechats-cache.py
   ```

### JSON parsing errors
**Symptoms**: "Invalid JSON" or jq parsing errors

**Solutions**:
1. Check jq version:
   ```bash
   jq --version
   ```

2. Update jq if needed:
   ```bash
   brew upgrade jq  # macOS
   sudo apt-get update && sudo apt-get upgrade jq  # Ubuntu
   ```

3. Check for corrupted cache:
   ```bash
   python3 -m json.tool ~/.claude/temp/codechats_cache.json
   ```

## Interface Issues

### Garbled text or colors
**Symptoms**: Text appears garbled or colors don't work

**Solutions**:
1. Check terminal color support:
   ```bash
   echo $TERM
   ```

2. Test color output:
   ```bash
   echo -e "\033[0;32mGreen text\033[0m"
   ```

3. Use different terminal if needed

### Input not recognized
**Symptoms**: Menu choices not working correctly

**Solutions**:
1. Ensure using bash or zsh
2. Check for input method conflicts
3. Try typing choices in lowercase

## Performance Issues

### Slow startup
**Symptoms**: CodeChats Manager takes long time to start

**Solutions**:
1. Check conversation count:
   ```bash
   find ~/.claude/projects -name "*.jsonl" | wc -l
   ```

2. If >1000 conversations, consider archiving old ones
3. Monitor cache generation time

### High memory usage
**Symptoms**: System becomes slow when using CodeChats Manager

**Solutions**:
1. Limit displayed conversations (edit script DISPLAY_LIMIT)
2. Archive old conversation files
3. Monitor Python process memory usage

## Search Issues

### Search returns no results
**Symptoms**: Search finds nothing despite knowing content exists

**Solutions**:
1. Try different search terms
2. Check file encoding:
   ```bash
   file ~/.claude/projects/path/to/conversation.jsonl
   ```

3. Manual search to verify content:
   ```bash
   grep -i "search_term" ~/.claude/projects/path/to/conversation.jsonl
   ```

## Platform-Specific Issues

### macOS Issues
- **Clipboard not working**: Install pbcopy (should be default)
- **Permission errors**: Check System Preferences > Security & Privacy

### Linux Issues
- **Clipboard not working**: Install xclip: `sudo apt-get install xclip`
- **Date parsing errors**: Ensure GNU date is installed

### WSL Issues
- **File permissions**: Check Windows/Linux file permission mapping
- **Path issues**: Ensure using Linux-style paths

## Debug Mode

Enable debug output for troubleshooting:
```bash
DEBUG=1 codechats
```

This provides detailed information about:
- Cache generation process
- File parsing results
- Navigation state changes
- Error details

## Getting Help

If issues persist:

1. **Check logs**: Look for error messages in terminal output
2. **Gather information**: System details, error messages, steps to reproduce
3. **Search issues**: Check GitHub issues for similar problems
4. **Create issue**: File detailed bug report with reproduction steps

## Emergency Recovery

If CodeChats Manager becomes unusable:

```bash
# Remove all temporary files
rm -rf ~/.claude/temp/codechats*
rm -rf ~/.claude/temp/nav_state.json
rm -rf ~/.claude/temp/*.tmp

# Reinstall
curl -sSL https://raw.githubusercontent.com/your-repo/codechats-manager/main/install.sh | bash
```

**Warning**: This removes all cached data but preserves original conversation files.
