# 🐱 Catclip - Smart Clipboard Utilities for Zsh

```
    /\_/\  
   ( o.o ) 
    > ^ <  
```

**Cat your files, Clip your workflow** 📋✨

Catclip makes working with file contents effortless by providing intelligent clipboard utilities that learn from your usage patterns. Copy files, directories, and code snippets with simple commands while gaining insights into your workflow.

## What Catclip Does

Catclip helps you work smarter with file contents by providing:
- **Smart file copying**: `catclip file.txt` copies content directly to clipboard
- **Line-specific copying**: `catclipn file.py 10 20` copies specific line ranges
- **Multi-file support**: `catclip *.js` copies multiple files with separators
- **Directory utilities**: `pwdclip`, `lsclip` for path and listing operations
- **Workflow insights**: Learn about your clipboard usage patterns

## The 80-20 Human-in-the-Loop Philosophy

Catclip follows the **80-20 Human-in-the-Loop** principle that makes technology work for humans, not the other way around:

### 80% Computer Help 🤖
- **Automatic clipboard detection**: Works with xclip, xsel, or wl-copy automatically
- **Smart file handling**: Detects file types and applies appropriate formatting
- **Cross-platform compatibility**: Works across Linux distributions and Wayland/X11
- **Efficient batch operations**: Handles multiple files intelligently
- **Usage analytics**: Tracks patterns to suggest optimizations

### 20% Human Control 🧠
- **Simple, memorable commands**: Easy-to-remember command names (`catclip`, not `cc-f-to-cb`)
- **Flexible usage patterns**: Adapt commands to your specific workflow needs
- **Conscious decision making**: You choose what and when to copy
- **Learning insights**: Understand your own file access patterns
- **Customizable behavior**: Configure to match your working style

This approach ensures you stay in control while technology removes the tedious parts of file manipulation.

## Global Accessibility & Fair Design

Catclip is designed to work everywhere for everyone:
- **Low resource usage**: Works on older hardware and limited environments
- **Simple English**: Clear documentation that translates well
- **No internet required**: Core functionality works completely offline
- **Cross-distro compatibility**: Works across different Linux distributions
- **Cultural neutrality**: Examples work in any development context

## Getting Started

### Step 1: Install Catclip

**Option A: Using Oh My Zsh** (Recommended)

1. Copy Catclip to your plugins folder:
```bash
git clone https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/catclip
```

2. Add Catclip to your plugin list. Open `~/.zshrc` and find the plugins line:
```bash
plugins=(git catclip)  # Add catclip here
```

3. Restart your terminal or run:
```bash
source ~/.zshrc
```

**Option B: Manual Installation**

1. Copy Catclip to your computer:
```bash
git clone https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin.git \
  ~/projects/zshplugs/catclip
```

2. Add this line to your `~/.zshrc` file:
```bash
source ~/projects/zshplugs/catclip/catclip.plugin.zsh
```

3. Restart your terminal or run:
```bash
source ~/.zshrc
```

### Step 2: Try Your First Copy

After installation, Catclip works immediately:

```bash
# Copy a file's contents
catclip README.md

# Copy with line numbers
catclipl config.json

# Copy specific lines
catclipn script.py 15 30

# Copy and show on screen
catclips important.txt
```

### Step 3: Explore Advanced Features

```bash
# Copy current directory path
pwdclip

# Copy directory listing
lsclip

# Show what's in your clipboard
clipshow
```

## Command Reference

### Basic File Operations

```bash
catclip <file>           # Copy file contents to clipboard
catclipl <file>          # Copy with line numbers
catclips <file>          # Copy and display on screen
catclipn <file> <start> <end>  # Copy specific line range
```

### Directory Operations

```bash
pwdclip                  # Copy current directory path
lsclip [options]         # Copy directory listing
clipshow                 # Display clipboard contents with stats
```

### Multi-File Support

```bash
catclip file1.txt file2.txt    # Copy multiple files
catclip *.py                   # Copy all Python files
catclip src/*.js              # Copy all JavaScript files in src/
```

### Understanding the Output

When you successfully copy content, you'll see:
```
✓ Contents of 'myfile.txt' copied to clipboard using xclip
```

For multiple files:
```
✓ Contents of 3 files copied to clipboard: file1.txt file2.txt file3.txt
```

## Advanced Usage

### Cross-Platform Clipboard Support

Catclip automatically detects and uses the best clipboard utility available:

1. **xclip** (X11 - most common)
2. **xsel** (X11 alternative)  
3. **wl-copy** (Wayland)

No configuration needed - it just works!

### File Type Intelligence

Catclip adds helpful separators when copying multiple files:

```bash
catclip config.py utils.py
```

Creates clipboard content like:
```
# === config.py ===
[config.py contents]

# === utils.py ===
[utils.py contents]
```

### Large File Handling

Catclip handles large files efficiently:
- Files over 1MB get a confirmation prompt
- Memory usage is monitored and reported
- Streaming processing for very large files

### Error Handling

Catclip provides clear, helpful error messages:

```bash
catclip nonexistent.txt
# Error: File 'nonexistent.txt' not found

catclipn script.py 50 25  
# Error: Start line (50) cannot be greater than end line (25)
```

## Configuration & Customization

### Environment Variables

Customize Catclip behavior with environment variables:

```bash
# Force specific clipboard utility
export CATCLIP_CLIPBOARD_CMD="xclip"

# Set custom file separator for multi-file copies  
export CATCLIP_SEPARATOR="# --- FILE: %s ---"

# Disable confirmation for large files
export CATCLIP_CONFIRM_LARGE="false"

# Set large file threshold (default: 1MB)
export CATCLIP_LARGE_FILE_MB="5"
```

### Plugin Configuration

Add these settings to your `.zshrc` for custom behavior:

```bash
# Custom aliases for your workflow
alias cc='catclip'           # Shorter command
alias ccl='catclipl'         # Copy with line numbers
alias ccs='catclips'         # Copy and show

# Integration with your editor
alias vclip='catclip $(fzf)' # Use fzf to select file to copy
```

## Workflow Integration Examples

### With Git

```bash
# Copy current diff
git diff | xclip -selection clipboard

# Copy specific file from another branch
git show main:config.py | xclip -selection clipboard

# Copy commit message
git log -1 --pretty=%B | xclip -selection clipboard
```

### With Development

```bash
# Copy test file and run tests
catclip test_user.py && npm test

# Copy config for deployment
catclip config/production.yml

# Copy error logs for debugging
catclip logs/error.log
```

### With Documentation

```bash
# Copy README sections
catclipn README.md 50 100

# Copy code examples
catclip examples/*.py

# Copy configuration examples
catclip config.example.json
```

## Usage Analytics & Insights

Catclip tracks your usage patterns to help you work better:

### What Gets Tracked
- Most copied file types
- Average file sizes copied
- Usage patterns by time of day
- Frequently copied directories
- Clipboard utility performance

### Viewing Your Insights
```bash
catclip --insights    # Show usage analytics
catclip --stats       # Show clipboard statistics
catclip --patterns    # Show workflow patterns
```

Example insights display:
```
📊 Catclip Usage Insights

📋 Clipboard Activity (Last 7 days):
  • 127 files copied
  • 2.3 MB average file size
  • Most active: 2-4 PM (32% of usage)

📁 File Types:
  • Python files: 45% (57 files)
  • Configuration: 23% (29 files)  
  • Documentation: 18% (23 files)
  • Other: 14% (18 files)

🗂️ Most Copied Directories:
  1. ~/projects/myapp/src (34 copies)
  2. ~/config (22 copies)
  3. ~/Documents/notes (18 copies)

💡 Optimization Suggestions:
  • Consider creating aliases for frequently copied files
  • Your config files could benefit from templates
```

## Troubleshooting

### Clipboard Not Working?

1. **Check available clipboard utilities:**
```bash
which xclip xsel wl-copy
```

2. **Install a clipboard utility:**
```bash
# Ubuntu/Debian
sudo apt install xclip

# Fedora/RHEL
sudo dnf install xclip

# Arch Linux  
sudo pacman -S xclip
```

3. **Test clipboard manually:**
```bash
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o
```

### Commands Not Found?

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
ls -la ~/projects/zshplugs/catclip/
```

### Large Files Causing Issues?

1. **Check available memory:**
```bash
free -h
```

2. **Use line ranges for large files:**
```bash
# Instead of: catclip huge_file.txt
catclipn huge_file.txt 1 100    # Copy first 100 lines
```

3. **Increase large file threshold:**
```bash
export CATCLIP_LARGE_FILE_MB="10"  # Allow 10MB files
```

### Permission Issues?

1. **Check file permissions:**
```bash
ls -la filename.txt
```

2. **Check clipboard utility permissions:**
```bash
ls -la $(which xclip)
```

## Contributing

We welcome contributions to make Catclip better for everyone!

### Ways to Contribute

- **Bug Reports**: Found an issue? Report it on GitHub Issues
- **Feature Requests**: Have an idea? Share it in GitHub Discussions  
- **Code Contributions**: Submit pull requests for improvements
- **Documentation**: Help improve examples and guides
- **Testing**: Test on different distributions and environments

### Development Setup

1. **Fork and clone:**
```bash
git clone https://github.com/your-username/Catclip-ZSH-Plugin.git
cd Catclip-ZSH-Plugin
```

2. **Create feature branch:**
```bash
git checkout -b feature/your-feature-name
```

3. **Test your changes:**
```bash
# Test installation
./install.sh --dev

# Test functionality
./test/run_tests.sh
```

4. **Follow our coding standards:**
   - Clear, readable shell script code
   - Comprehensive error handling
   - Cross-platform compatibility
   - Documentation for new features

### Code of Conduct

Catclip follows the 80-20 Human-in-the-Loop principles:
- **Inclusive**: Everyone is welcome regardless of experience level
- **Helpful**: We focus on helping people work better
- **Respectful**: All interactions should be constructive and kind
- **Global**: Consider users from different backgrounds and environments

## Support

Need help? Have questions?

- **Issues**: [GitHub Issues](https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin/discussions)
- **Documentation**: [Full Documentation](https://catclip.example.com/docs)

## License

GPL-3.0 License - Catclip is free software that stays free. 

This means:
- ✅ You can use Catclip for any purpose
- ✅ You can study and modify the source code
- ✅ You can distribute copies to help others
- ✅ You can distribute your modifications

If you improve Catclip, sharing those improvements helps everyone. See [LICENSE](LICENSE) file for full details.

## Roadmap

### Coming Soon
- **Smart Templates**: Automatically detect and suggest clipboard templates
- **Encrypted Clipboard**: Secure clipboard for sensitive files
- **Remote Clipboard**: Sync clipboard across multiple machines
- **VS Code Integration**: Direct integration with VS Code editor
- **Web Interface**: Browser-based clipboard management

### Future Ideas
- **AI-Powered Suggestions**: Smart file content recommendations
- **Team Sharing**: Secure clipboard sharing within development teams
- **API Access**: Programmatic access to clipboard operations
- **Mobile Companion**: Mobile app for clipboard access

## Acknowledgments

Catclip is built with love by the **80-20 Human-in-the-Loop** community, inspired by the idea that technology should amplify human capabilities, not replace human judgment.

Special thanks to:
- The Zsh community for creating an amazing shell
- The clipboard utility maintainers (xclip, xsel, wl-copy)
- PathWise project for plugin architecture inspiration
- All contributors and users who make Catclip better

---

**Catclip** - Cat your files, Clip your workflow 🐱📋

*Making file copying as natural as a cat's purr.*

Made with care by the 80-20 Human-In-The-Loop community.