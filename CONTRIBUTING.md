# Contributing to Catclip

Thank you for your interest in contributing to Catclip! We follow the **80-20 Human-in-the-Loop** philosophy: 80% automation, 20% human wisdom, 100% workflow optimization.

## 🐱 Our Philosophy

When contributing to Catclip, please keep these principles in mind:

1. **Workflow Enhancement**: Features should help users work more efficiently with file content
2. **Human Control**: Users should understand and control what's being copied and when
3. **Transparency**: Code should be readable and well-documented with clear examples
4. **Privacy First**: Never collect or transmit user data without explicit consent
5. **Educational Value**: Help users understand their clipboard usage patterns

## 🤝 How to Contribute

### Reporting Issues

- Check existing issues first
- Provide clear reproduction steps
- Include your Zsh version, OS, and clipboard utility (xclip/xsel/wl-copy)
- Describe expected vs actual behavior
- Include relevant error messages

### Suggesting Features

Features that align with our philosophy:
- ✅ Help users understand their file copying patterns
- ✅ Provide actionable workflow insights
- ✅ Respect user privacy and data
- ✅ Educate about efficient file handling
- ✅ Cross-platform compatibility improvements
- ✅ Smart file type detection and handling

Features we avoid:
- ❌ Complete automation without user understanding
- ❌ Data collection without user control
- ❌ Complex features that hide functionality
- ❌ Features that compromise security or privacy

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes following our code style
4. Test thoroughly (see testing section)
5. Update documentation if needed
6. Commit with clear messages: `git commit -m 'Add feature: description'`
7. Push to your fork: `git push origin feature/your-feature-name`
8. Open a Pull Request with detailed description

### Code Style

- Use meaningful variable and function names
- Comment complex logic with clear explanations
- Follow existing zsh scripting patterns
- Keep functions focused and small
- Add inline documentation for learning
- Use consistent error handling and messaging
- Include usage examples for new features

### Testing

Before submitting, test your changes with:

#### Basic Functionality
```bash
# Test basic operations
catclip README.md
catclipl LICENSE
catclips CONTRIBUTING.md
catclipn README.md 1 10
pwdclip
lsclip
clipshow
```

#### Edge Cases
```bash
# Test edge cases
catclip nonexistent.txt        # Should handle errors gracefully
catclip *.nonexistent          # Test glob expansion failures
catclipn README.md 50 25       # Test invalid line ranges
catclip /dev/null              # Test empty files
```

#### Multiple Environments
- Test with fresh installation
- Test with existing data files
- Test with different clipboard utilities (xclip, xsel, wl-copy)
- Test with and without Oh My Zsh
- Verify backward compatibility

#### Performance Testing
```bash
# Test with large files (if implementing file size features)
catclip --insights            # Test analytics generation
catclip --stats              # Test performance metrics
```

## 📚 Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/Catclip-ZSH-Plugin.git
cd Catclip-ZSH-Plugin

# Create a test installation
./install.sh local

# For Oh My Zsh users, create a development symlink
ln -sf $(pwd)/catclip.plugin.zsh ~/.oh-my-zsh/custom/plugins/catclip-dev/catclip.plugin.zsh

# Add catclip-dev to your plugins for testing
# Edit ~/.zshrc: plugins=(... catclip-dev)

# Reload shell to test changes
source ~/.zshrc
```

### Development Workflow

1. **Make changes** to `catclip.plugin.zsh`
2. **Reload shell**: `source ~/.zshrc` 
3. **Test functionality** with various commands
4. **Check analytics** with `catclip --insights`
5. **Verify no regressions** with existing features

## 🎓 Learning Resources

- [Zsh Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)
- [Oh My Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Advanced Bash Scripting Guide](https://tldp.org/LDP/abs/html/)
- [80-20 Philosophy](https://github.com/80-20-Human-In-The-Loop/Community)
- [Clipboard Utilities Documentation](https://linux.die.net/man/1/xclip)

## 💡 Feature Ideas

We're especially interested in contributions for:

### Workflow Analytics
- Advanced usage pattern analysis
- Workflow optimization suggestions
- File type and size trend analysis
- Peak usage time identification

### Smart Features  
- Intelligent file content formatting
- Context-aware clipboard operations
- Integration with development tools (git, editors)
- Template and snippet management

### Cross-Platform Improvements
- Enhanced Wayland support
- macOS clipboard integration
- Windows WSL compatibility
- Remote clipboard synchronization

### Educational Features
- Interactive workflow tutorials
- Best practice recommendations
- Performance optimization tips
- Security awareness for sensitive files

### Team Collaboration
- Export formats for team knowledge sharing
- Workflow pattern sharing (privacy-respecting)
- Team clipboard usage insights
- Integration with team communication tools

## 📝 Documentation

When adding features:

### Update README.md
- Add new commands to command reference
- Include usage examples
- Update configuration options
- Add troubleshooting information

### Add to docs/ Directory
- Create detailed guides for complex features
- Include real-world workflow examples
- Document the "why" not just the "what"
- Add learning points for users

### Create Examples
- Add workflow examples to `examples/` directory
- Include integration scenarios
- Show before/after comparisons
- Demonstrate 80-20 philosophy in action

### Update Help Text
- Update `catclip --help` with new features
- Ensure error messages are clear and actionable
- Add educational context to complex features

## 🌟 Recognition

Contributors who align with our philosophy will be:
- Added to CONTRIBUTORS.md with their contributions highlighted
- Mentioned in release notes and changelogs
- Invited to help shape future project direction
- Featured in community showcases

## 📜 License

By contributing, you agree that your contributions will be licensed under the GPL-3.0 License, ensuring Catclip remains free and open source.

## 🎯 Quality Standards

### Code Quality
- All functions should have clear, single purposes
- Error handling should be consistent and user-friendly
- Performance impact should be minimal
- Memory usage should be efficient

### User Experience  
- Commands should be intuitive and memorable
- Output should be clear and informative
- Configuration should be optional with good defaults
- Analytics should be helpful, not overwhelming

### Security Considerations
- Never log sensitive file contents
- Respect file permissions and access controls
- Warn users about potentially sensitive operations
- Provide secure defaults for all configurations

## 🚀 Release Process

1. **Feature development** in feature branches
2. **Testing** across multiple environments
3. **Documentation updates** including examples
4. **Version bump** following semantic versioning
5. **Release notes** highlighting new features and changes
6. **Community announcement** with migration guidance

## 🙏 Thank You!

Every contribution, no matter how small, helps make Catclip better for developers worldwide. Together, we're building tools that enhance human capability rather than replace human judgment.

Your contributions help people work more efficiently with file content while maintaining full control over their workflow. That's the essence of the 80-20 philosophy in action.

---

*Remember: The goal isn't just to copy files faster, but to copy files wiser.* 🐱📋

**Happy contributing!**