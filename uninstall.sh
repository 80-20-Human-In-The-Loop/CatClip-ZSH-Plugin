#!/bin/bash
# Catclip Uninstall Script
# Clean removal of Catclip plugin

set -e

BOLD=$'\033[1m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
NC=$'\033[0m' # No Color

echo -e "${BOLD}${BLUE}🐱 Catclip Uninstaller${NC}"
echo -e "${BOLD}Removing Catclip from your system${NC}"
echo ""

# Detect installation type
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/catclip" ]; then
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/catclip"
    OMZ_INSTALL=true
    echo -e "${BLUE}ℹ${NC} Oh My Zsh installation detected"
elif [ -d "$HOME/.catclip" ]; then
    PLUGIN_DIR="$HOME/.catclip"
    OMZ_INSTALL=false
    echo -e "${BLUE}ℹ${NC} Manual installation detected"
else
    echo -e "${RED}✗${NC} Catclip installation not found"
    echo ""
    echo "Catclip does not appear to be installed on this system."
    echo "If you have catclip functions in your .zshrc, you may need to remove them manually."
    exit 1
fi

echo -e "Installation directory: ${YELLOW}$PLUGIN_DIR${NC}"
echo ""

# Confirm uninstall
read -p "Are you sure you want to uninstall Catclip? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled"
    exit 0
fi

echo ""
echo -e "${BLUE}→${NC} Removing Catclip files..."

# 1. Remove plugin directory
if [ -d "$PLUGIN_DIR" ]; then
    rm -rf "$PLUGIN_DIR"
    echo -e "${GREEN}✓${NC} Removed plugin directory"
else
    echo -e "${YELLOW}⚠${NC} Plugin directory not found"
fi

# 2. Clean up .zshrc
echo -e "${BLUE}→${NC} Cleaning .zshrc configuration..."

if [ -f "$HOME/.zshrc" ]; then
    # Create backup
    cp "$HOME/.zshrc" "$HOME/.zshrc.catclip-backup"
    echo -e "${GREEN}✓${NC} Created backup at ~/.zshrc.catclip-backup"
    
    if [ "$OMZ_INSTALL" = true ]; then
        # Remove from Oh My Zsh plugins list
        if grep -q "catclip" "$HOME/.zshrc"; then
            # Remove catclip from plugins list (handles various formats)
            sed -i.tmp 's/ catclip//g; s/catclip //g; s/(catclip)/()/g' "$HOME/.zshrc"
            echo -e "${GREEN}✓${NC} Removed from Oh My Zsh plugins"
        fi
    else
        # Remove manual source line
        if grep -q "catclip.plugin.zsh" "$HOME/.zshrc"; then
            # Remove Catclip source line and its comment
            sed -i.tmp '/# Catclip - Cat your files, Clip your workflow/d' "$HOME/.zshrc"
            sed -i.tmp '/catclip.plugin.zsh/d' "$HOME/.zshrc"
            echo -e "${GREEN}✓${NC} Removed manual source configuration"
        fi
    fi
    
    # Check for old clipboard functions that might conflict
    OLD_FUNCTIONS_FOUND=false
    if grep -q "# CLIPBOARD UTILITIES SUITE" "$HOME/.zshrc"; then
        echo -e "${YELLOW}⚠${NC} Found old clipboard utilities in .zshrc"
        OLD_FUNCTIONS_FOUND=true
    fi
    
    # Clean up temp files
    rm -f "$HOME/.zshrc.tmp"
else
    echo -e "${YELLOW}⚠${NC} .zshrc not found"
fi

# 3. Remove data files (optional)
echo ""
echo -e "${BLUE}→${NC} Catclip data files found:"
DATA_FILES=(
    "$HOME/.catclip.config"
    "$HOME/.catclip.analytics"
    "$HOME/.catclip.history"
    "$HOME/.catclip.session"
    "$HOME/.catclip.session.init"
    "$HOME/.catclip.analytics.perf"
)

FOUND_DATA=false
for file in "${DATA_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "   ${YELLOW}•${NC} $file"
        FOUND_DATA=true
    fi
done

if [ "$FOUND_DATA" = true ]; then
    echo ""
    echo -e "${BLUE}These files contain your clipboard usage analytics and configuration.${NC}"
    read -p "Do you want to remove Catclip data files? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for file in "${DATA_FILES[@]}"; do
            if [ -f "$file" ]; then
                rm -f "$file"
            fi
        done
        echo -e "${GREEN}✓${NC} Removed data files"
    else
        echo -e "${BLUE}ℹ${NC} Data files preserved for future use"
    fi
else
    echo -e "   ${GREEN}None found${NC}"
fi

# 4. Clean up any remaining empty lines in .zshrc
if [ -f "$HOME/.zshrc" ]; then
    # Remove multiple consecutive empty lines
    sed -i.tmp '/^$/N;/^\n$/d' "$HOME/.zshrc"
    rm -f "$HOME/.zshrc.tmp"
fi

# 5. Inform about old clipboard functions
if [ "$OLD_FUNCTIONS_FOUND" = true ]; then
    echo ""
    echo -e "${YELLOW}📝 Note about old clipboard functions:${NC}"
    echo "Your .zshrc still contains old clipboard utilities (CLIPBOARD UTILITIES SUITE)."
    echo "These were likely replaced by Catclip. You may want to:"
    echo "  1. Keep them if you prefer the old functions"
    echo "  2. Remove them to avoid conflicts with future Catclip installations"
    echo ""
    read -p "Would you like to remove the old clipboard functions now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove the entire clipboard utilities section
        sed -i.bak2 '/# CLIPBOARD UTILITIES SUITE/,/^$/d' "$HOME/.zshrc"
        echo -e "${GREEN}✓${NC} Removed old clipboard utilities from .zshrc"
    else
        echo -e "${BLUE}ℹ${NC} Old clipboard functions preserved"
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}✨ Catclip has been uninstalled${NC}"
echo ""
echo -e "${BOLD}Notes:${NC}"
echo -e "  • A backup of your .zshrc was saved to: ${BLUE}~/.zshrc.catclip-backup${NC}"
echo -e "  • Please reload your shell: ${BLUE}source ~/.zshrc${NC}"
if [ "$FOUND_DATA" = true ] && [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "  • Your usage analytics have been preserved"
fi
if [ "$OLD_FUNCTIONS_FOUND" = true ]; then
    echo -e "  • Check your .zshrc for any remaining clipboard functions"
fi
echo ""
echo -e "Thanks for trying Catclip! 🐱📋"
echo ""
echo -e "${BLUE}Feedback helps us improve:${NC}"
echo -e "  • Issues: https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin/issues"
echo -e "  • Discussions: https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin/discussions"