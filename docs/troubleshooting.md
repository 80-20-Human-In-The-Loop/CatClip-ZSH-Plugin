# Catclip Troubleshooting Guide

This guide helps you resolve common issues and optimize Catclip performance.

## 🚨 Common Issues

### Clipboard Not Working

**Symptoms:**
- Commands run but nothing is copied to clipboard
- Error messages about clipboard utilities
- `clipshow` displays nothing or errors

**Solutions:**

1. **Check clipboard utility availability:**
```bash
# Check what's installed
which xclip xsel wl-copy
```

2. **Install a clipboard utility:**
```bash
# Ubuntu/Debian
sudo apt install xclip

# Fedora/RHEL/CentOS
sudo dnf install xclip

# Arch Linux
sudo pacman -S xclip

# Wayland users
sudo apt install wl-clipboard
```

3. **Test clipboard manually:**
```bash
# Test xclip
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o

# Test xsel
echo "test" | xsel --clipboard --input
xsel --clipboard --output

# Test wl-copy (Wayland)
echo "test" | wl-copy
wl-paste
```

4. **Force specific clipboard utility:**
```bash
# Add to ~/.catclip.config
CATCLIP_CLIPBOARD_CMD="xclip"   # or "xsel" or "wl-copy"
```

### Commands Not Found

**Symptoms:**
- `catclip: command not found`
- `clipshow: command not found`
- Functions don't work after installation

**Solutions:**

1. **Check if Catclip is loaded:**
```bash
echo $CATCLIP_LOADED
# Should show: true
```

2. **Reload your shell:**
```bash
source ~/.zshrc
```

3. **Check installation path:**
```bash
# For Oh My Zsh
ls -la ~/.oh-my-zsh/custom/plugins/catclip/

# For manual installation
ls -la ~/.catclip/
```

4. **Verify plugin configuration:**
```bash
# Check Oh My Zsh plugins
grep "plugins=" ~/.zshrc

# Check manual source line
grep "catclip.plugin.zsh" ~/.zshrc
```

5. **Reinstall if needed:**
```bash
./install.sh local
source ~/.zshrc
```

### Function Conflicts

**Symptoms:**
- Old clipboard functions still work instead of Catclip
- Unexpected behavior from clipboard commands
- Multiple functions with same name

**Solutions:**

1. **Check for function conflicts:**
```bash
# Check what functions are defined
which catclip
type catclip
```

2. **Remove old functions from .zshrc:**
```bash
# Look for old clipboard functions
grep -n "catclip\|_clip_copy\|CLIPBOARD UTILITIES" ~/.zshrc
```

3. **Use the uninstaller to clean up:**
```bash
./uninstall.sh
# Choose to remove old functions when prompted
./install.sh
```

4. **Manual cleanup:**
```bash
# Edit ~/.zshrc and remove sections like:
# # CLIPBOARD UTILITIES SUITE
# ...old functions...
```

### Permission Issues

**Symptoms:**
- "Permission denied" errors
- Cannot access certain files
- Clipboard utility fails silently

**Solutions:**

1. **Check file permissions:**
```bash
ls -la filename.txt
```

2. **Check clipboard utility permissions:**
```bash
ls -la $(which xclip)
# Should show executable permissions
```

3. **Fix clipboard utility permissions:**
```bash
# If needed
sudo chmod +x $(which xclip)
```

4. **Check for SELinux/AppArmor restrictions:**
```bash
# Check SELinux status
sestatus

# Check for denied operations
sudo ausearch -m avc -ts recent
```

## 🐛 Performance Issues

### Slow Performance

**Symptoms:**
- Long delays when copying files
- System becomes unresponsive
- High memory usage

**Solutions:**

1. **Check file sizes:**
```bash
# Large files can slow things down
ls -lah filename.txt
```

2. **Use line ranges for large files:**
```bash
# Instead of copying entire large file
catclipn huge_file.txt 1 100    # Copy first 100 lines
```

3. **Disable analytics temporarily:**
```bash
# Add to ~/.catclip.config
CATCLIP_TRACK_USAGE="false"
CATCLIP_CLIPBOARD_STATS="false"
```

4. **Check system resources:**
```bash
# Monitor memory usage
free -h

# Monitor CPU usage during operations
top
```

5. **Optimize configuration:**
```bash
# Reduce large file threshold
# Add to ~/.catclip.config
CATCLIP_LARGE_FILE_MB="0.5"   # Warn at 500KB instead of 1MB
```

### Memory Issues

**Symptoms:**
- Out of memory errors
- System swap usage increases
- Very slow performance with large files

**Solutions:**

1. **Check current memory usage:**
```bash
# Show memory stats
catclip --stats
```

2. **Use streaming for large files:**
```bash
# Instead of catclip huge_file.txt
head -n 1000 huge_file.txt | xclip -selection clipboard
```

3. **Clear clipboard cache:**
```bash
# Clear analytics data
rm -f ~/.catclip.analytics ~/.catclip.history
```

4. **Process files in chunks:**
```bash
# For very large files, process in sections
catclipn large_file.txt 1 500      # First 500 lines
catclipn large_file.txt 501 1000   # Next 500 lines
```

## 🔧 Configuration Issues

### Analytics Not Working

**Symptoms:**
- `catclip --insights` shows no data
- No usage patterns recorded
- Performance stats missing

**Solutions:**

1. **Check analytics configuration:**
```bash
# Verify tracking is enabled
catclip --config
```

2. **Enable analytics:**
```bash
# Add to ~/.catclip.config
CATCLIP_TRACK_USAGE="true"
CATCLIP_CLIPBOARD_STATS="true"
```

3. **Check data files:**
```bash
# Verify analytics files exist
ls -la ~/.catclip.*
```

4. **Reset analytics:**
```bash
# Clear and restart
rm -f ~/.catclip.analytics ~/.catclip.history
# Use catclip a few times, then check:
catclip --insights
```

### Configuration Not Loading

**Symptoms:**
- Changes to ~/.catclip.config don't take effect
- Default settings always used
- Custom settings ignored

**Solutions:**

1. **Check config file syntax:**
```bash
# Verify proper shell syntax
bash -n ~/.catclip.config
```

2. **Reload configuration:**
```bash
source ~/.zshrc
```

3. **Check config file location:**
```bash
echo $CATCLIP_CONFIG
ls -la ~/.catclip.config
```

4. **Create config with proper format:**
```bash
cat > ~/.catclip.config << 'EOF'
CATCLIP_TRACK_USAGE="true"
CATCLIP_LARGE_FILE_MB="1"
CATCLIP_AUTO_SEPARATORS="true"
EOF
```

## 🖥️ Platform-Specific Issues

### Wayland Issues

**Symptoms:**
- Clipboard not working in Wayland session
- xclip/xsel not functioning
- Copy operations silently fail

**Solutions:**

1. **Install Wayland clipboard utility:**
```bash
sudo apt install wl-clipboard
```

2. **Verify Wayland session:**
```bash
echo $XDG_SESSION_TYPE
# Should show: wayland
```

3. **Test wl-copy directly:**
```bash
echo "test" | wl-copy
wl-paste
```

4. **Force Wayland clipboard:**
```bash
# Add to ~/.catclip.config
CATCLIP_CLIPBOARD_CMD="wl-copy"
```

### SSH/Remote Sessions

**Symptoms:**
- Clipboard not working over SSH
- Local clipboard not updated
- X11 forwarding issues

**Solutions:**

1. **Enable X11 forwarding:**
```bash
ssh -X user@remote-host
# or
ssh -Y user@remote-host
```

2. **Check X11 forwarding:**
```bash
echo $DISPLAY
# Should show something like localhost:10.0
```

3. **Use clipboard synchronization:**
```bash
# Copy to local clipboard via SSH
catclip file.txt
# Then on local machine:
ssh remote-host 'clipshow' | xclip -selection clipboard
```

4. **Alternative for SSH:**
```bash
# Save to file and transfer
catclip file.txt > /tmp/clipboard_content.txt
scp remote:/tmp/clipboard_content.txt .
catclip clipboard_content.txt
```

### macOS Issues

**Symptoms:**
- pbcopy/pbpaste not working
- Different clipboard behavior
- BSD vs GNU command differences

**Solutions:**

1. **Install GNU utilities:**
```bash
brew install coreutils gnu-sed
```

2. **Create macOS-specific config:**
```bash
# Add to ~/.catclip.config
if [[ "$OSTYPE" == "darwin"* ]]; then
    CATCLIP_CLIPBOARD_CMD="pbcopy"
fi
```

3. **Use macOS clipboard directly:**
```bash
# Test pbcopy/pbpaste
echo "test" | pbcopy
pbpaste
```

## 📊 Diagnostic Commands

### System Information

```bash
# Get system info for bug reports
echo "=== System Information ==="
uname -a
echo "Zsh version: $ZSH_VERSION"
echo "Session type: $XDG_SESSION_TYPE"

echo "=== Clipboard Utilities ==="
which xclip xsel wl-copy pbcopy 2>/dev/null

echo "=== Catclip Status ==="
echo "Loaded: $CATCLIP_LOADED"
echo "Version: $CATCLIP_VERSION"

echo "=== Configuration ==="
ls -la ~/.catclip.*
```

### Debug Mode

```bash
# Enable debug output
set -x
catclip test_file.txt
set +x

# Check function definitions
type catclip
type _clip_copy
```

### Test Suite

```bash
# Basic functionality test
echo "=== Testing Catclip ==="

# Create test file
echo "Test content $(date)" > /tmp/catclip_test.txt

# Test basic copy
catclip /tmp/catclip_test.txt
if [ $? -eq 0 ]; then
    echo "✓ Basic copy works"
else
    echo "✗ Basic copy failed"
fi

# Test clipboard show
clipshow > /dev/null
if [ $? -eq 0 ]; then
    echo "✓ Clipboard show works"
else
    echo "✗ Clipboard show failed"
fi

# Test line numbers
catclipl /tmp/catclip_test.txt
if [ $? -eq 0 ]; then
    echo "✓ Line numbers work"
else
    echo "✗ Line numbers failed"
fi

# Cleanup
rm -f /tmp/catclip_test.txt

echo "=== Test Complete ==="
```

## 🆘 Getting Help

### Before Reporting Issues

1. **Run diagnostics:**
```bash
# Collect system information
catclip --version 2>/dev/null || echo "Version: Unknown"
echo "System: $(uname -a)"
echo "Shell: $SHELL"
echo "Zsh: $ZSH_VERSION"
```

2. **Test with minimal config:**
```bash
# Temporarily rename config
mv ~/.catclip.config ~/.catclip.config.bak 2>/dev/null
source ~/.zshrc
# Test if issue persists
```

3. **Try fresh installation:**
```bash
./uninstall.sh
./install.sh local
```

### Reporting Issues

Include this information in bug reports:

```bash
# System information
uname -a
echo "Zsh: $ZSH_VERSION"
echo "Session: $XDG_SESSION_TYPE"

# Catclip information
echo "Loaded: $CATCLIP_LOADED"
ls -la ~/.oh-my-zsh/custom/plugins/catclip/ 2>/dev/null || ls -la ~/.catclip/

# Clipboard utilities
which xclip xsel wl-copy pbcopy 2>/dev/null

# Error reproduction steps
echo "Steps to reproduce:"
echo "1. Run: catclip filename.txt"
echo "2. Expected: File copied to clipboard"
echo "3. Actual: [describe what happens]"
```

### Community Support

- **GitHub Issues**: [Report bugs and request features](https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin/issues)
- **Discussions**: [Ask questions and share workflows](https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin/discussions)
- **Documentation**: [Read comprehensive guides](../README.md)

### Quick Fixes Reference

| Problem | Quick Fix |
|---------|-----------|
| Commands not found | `source ~/.zshrc` |
| No clipboard utility | `sudo apt install xclip` |
| Permission denied | `chmod +x ~/.oh-my-zsh/custom/plugins/catclip/catclip.plugin.zsh` |
| Large file issues | Use `catclipn file.txt 1 100` instead |
| Wayland not working | `sudo apt install wl-clipboard` |
| SSH clipboard issues | Use `ssh -X` for X11 forwarding |
| Config not loading | Check syntax with `bash -n ~/.catclip.config` |
| Analytics not working | Enable with `CATCLIP_TRACK_USAGE="true"` |

---

*Remember: The 80-20 philosophy means Catclip should work automatically 80% of the time. If you're spending more than 20% of your time troubleshooting, something needs fixing!* 🐱📋