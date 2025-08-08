#!/bin/bash
# Catclip Installation Script
# Cat your files, Clip your workflow 🐱📋

set -e

BOLD=$'\033[1m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
NC=$'\033[0m' # No Color

# Parse command line arguments
LOCAL_INSTALL=false
UPDATE_MODE=false

# Check for update mode first
if [ "$1" = "update" ] || [ "$1" = "--update" ]; then
    UPDATE_MODE=true
    if [ "$2" = "local" ]; then
        LOCAL_INSTALL=true
    fi
    echo -e "${BLUE}🔄 Updating Catclip...${NC}"
elif [ "$1" = "local" ]; then
    LOCAL_INSTALL=true
    echo -e "${YELLOW}📦 Local installation mode${NC}"
fi

# Show header only for non-update installs
if [ "$UPDATE_MODE" = false ]; then
    echo -e "${BOLD}${BLUE}🐱 Catclip Installer${NC}"
    echo -e "${BOLD}Cat your files, Clip your workflow${NC}"
    echo ""
fi

# Check if Zsh is installed on the system
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}Error: Catclip requires Zsh${NC}"
    if [ "$UPDATE_MODE" = false ]; then
        echo "Please install Zsh and try again"
        echo ""
        echo "Installation instructions:"
        echo "  Ubuntu/Debian: sudo apt install zsh"
        echo "  Fedora/RHEL:   sudo dnf install zsh"
        echo "  macOS:         brew install zsh"
        echo "  Arch:          sudo pacman -S zsh"
    fi
    exit 1
else
    if [ "$UPDATE_MODE" = false ]; then
        ZSH_PATH=$(command -v zsh)
        echo -e "${GREEN}✓${NC} Zsh detected at $ZSH_PATH"
    fi
fi

# Check for clipboard utilities
if [ "$UPDATE_MODE" = false ]; then
    echo -e "${BLUE}→${NC} Checking clipboard utilities..."
    CLIPBOARD_FOUND=false
    
    if command -v xclip &> /dev/null; then
        echo -e "${GREEN}✓${NC} xclip detected"
        CLIPBOARD_FOUND=true
    elif command -v xsel &> /dev/null; then
        echo -e "${GREEN}✓${NC} xsel detected"
        CLIPBOARD_FOUND=true
    elif command -v wl-copy &> /dev/null; then
        echo -e "${GREEN}✓${NC} wl-copy detected (Wayland)"
        CLIPBOARD_FOUND=true
    fi
    
    if [ "$CLIPBOARD_FOUND" = false ]; then
        echo -e "${YELLOW}⚠${NC} No clipboard utility detected"
        echo "Catclip works best with a clipboard utility:"
        echo "  Ubuntu/Debian: sudo apt install xclip"
        echo "  Fedora/RHEL:   sudo dnf install xclip" 
        echo "  Arch:          sudo pacman -S xclip"
        echo "  Wayland:       sudo apt install wl-clipboard"
        echo ""
        read -p "Continue installation without clipboard utility? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled"
            exit 0
        fi
    fi
fi

# Check for Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${GREEN}✓${NC} Oh My Zsh detected"
    fi
    OMZ_INSTALL=true
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/catclip"
else
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${YELLOW}ℹ${NC} Oh My Zsh not detected - using manual installation"
    fi
    OMZ_INSTALL=false
    PLUGIN_DIR="$HOME/.catclip"
fi

# Check if already installed
if [ -d "$PLUGIN_DIR" ]; then
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${YELLOW}⚠${NC} Catclip appears to be already installed at $PLUGIN_DIR"
        read -p "Do you want to reinstall/update? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled"
            exit 0
        fi
    fi
    rm -rf "$PLUGIN_DIR"
fi

# Install Catclip
if [ "$UPDATE_MODE" = false ]; then
    echo -e "${BLUE}→${NC} Installing Catclip..."
fi
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$LOCAL_INSTALL" = true ]; then
    # Local installation - copy from current directory
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${BLUE}→${NC} Installing from local files..."
    fi
    
    # Copy files from local directory
    mkdir -p "$PLUGIN_DIR"
    cp "$SCRIPT_DIR/catclip.plugin.zsh" "$PLUGIN_DIR/" 2>/dev/null
    [ -f "$SCRIPT_DIR/README.md" ] && cp "$SCRIPT_DIR/README.md" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/LICENSE" ] && cp "$SCRIPT_DIR/LICENSE" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/install.sh" ] && cp "$SCRIPT_DIR/install.sh" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/uninstall.sh" ] && cp "$SCRIPT_DIR/uninstall.sh" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/CONTRIBUTING.md" ] && cp "$SCRIPT_DIR/CONTRIBUTING.md" "$PLUGIN_DIR/"
    [ -d "$SCRIPT_DIR/docs" ] && cp -r "$SCRIPT_DIR/docs" "$PLUGIN_DIR/"
    [ -d "$SCRIPT_DIR/examples" ] && cp -r "$SCRIPT_DIR/examples" "$PLUGIN_DIR/"
    
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${GREEN}✓${NC} Installed from local files"
    fi
else
    # GitHub installation
    if command -v git &> /dev/null; then
        # Clone or pull from GitHub
        git clone https://github.com/80-20-Human-In-The-Loop/Catclip-ZSH-Plugin.git "$PLUGIN_DIR" 2>/dev/null || {
            # If GitHub repo doesn't exist yet, copy local files
            if [ -d "$SCRIPT_DIR" ]; then
                mkdir -p "$PLUGIN_DIR"
                # Copy only the necessary plugin files
                cp "$SCRIPT_DIR/catclip.plugin.zsh" "$PLUGIN_DIR/" 2>/dev/null
                [ -f "$SCRIPT_DIR/README.md" ] && cp "$SCRIPT_DIR/README.md" "$PLUGIN_DIR/"
                [ -f "$SCRIPT_DIR/LICENSE" ] && cp "$SCRIPT_DIR/LICENSE" "$PLUGIN_DIR/"
                [ -f "$SCRIPT_DIR/install.sh" ] && cp "$SCRIPT_DIR/install.sh" "$PLUGIN_DIR/"
                [ -f "$SCRIPT_DIR/uninstall.sh" ] && cp "$SCRIPT_DIR/uninstall.sh" "$PLUGIN_DIR/"
                [ -f "$SCRIPT_DIR/CONTRIBUTING.md" ] && cp "$SCRIPT_DIR/CONTRIBUTING.md" "$PLUGIN_DIR/"
                [ -d "$SCRIPT_DIR/docs" ] && cp -r "$SCRIPT_DIR/docs" "$PLUGIN_DIR/"
                [ -d "$SCRIPT_DIR/examples" ] && cp -r "$SCRIPT_DIR/examples" "$PLUGIN_DIR/"
                if [ "$UPDATE_MODE" = false ]; then
                    echo -e "${GREEN}✓${NC} Installed from local files"
                fi
            else
                echo -e "${RED}Error: Could not install Catclip${NC}"
                exit 1
            fi
        }
    else
        echo -e "${RED}Error: Git is required for installation${NC}"
        exit 1
    fi
fi

# Configure .zshrc (skip during updates - already configured)
if [ "$UPDATE_MODE" = false ]; then
    echo -e "${BLUE}→${NC} Configuring .zshrc..."
    
    # Check for existing clipboard functions in .zshrc and warn user
    if grep -q "catclip()" "$HOME/.zshrc" || grep -q "_clip_copy()" "$HOME/.zshrc"; then
        echo -e "${YELLOW}⚠${NC} Existing clipboard functions detected in .zshrc"
        echo "It looks like you have clipboard utilities already defined in your .zshrc."
        echo "Catclip will override these functions when loaded."
        echo ""
        read -p "Continue with installation? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled"
            echo "You can manually remove the existing functions and run this installer again."
            exit 0
        fi
        echo ""
        echo -e "${BLUE}→${NC} Note: Consider removing the old clipboard functions from .zshrc after installation"
    fi
    
    if [ "$OMZ_INSTALL" = true ]; then
        # Add to Oh My Zsh plugins
        if grep -q "^plugins=" "$HOME/.zshrc"; then
            # Check if catclip is already in plugins
            if ! grep -q "catclip" "$HOME/.zshrc"; then
                # Add catclip to existing plugins line
                sed -i.bak '/^plugins=/s/)/ catclip)/' "$HOME/.zshrc"
                echo -e "${GREEN}✓${NC} Added Catclip to Oh My Zsh plugins"
            else
                echo -e "${GREEN}✓${NC} Catclip already in plugins list"
            fi
        else
            echo -e "${YELLOW}⚠${NC} Could not find plugins line in .zshrc"
            echo "Please add 'catclip' to your plugins manually:"
            echo "  plugins=(... catclip)"
        fi
    else
        # Manual installation - add source line
        if ! grep -q "catclip.plugin.zsh" "$HOME/.zshrc"; then
            echo "" >> "$HOME/.zshrc"
            echo "# Catclip - Cat your files, Clip your workflow 🐱📋" >> "$HOME/.zshrc"
            echo "source $PLUGIN_DIR/catclip.plugin.zsh" >> "$HOME/.zshrc"
            echo -e "${GREEN}✓${NC} Added Catclip to .zshrc"
        else
            echo -e "${GREEN}✓${NC} Catclip already configured in .zshrc"
        fi
    fi
fi

# Success message
if [ "$UPDATE_MODE" = true ]; then
    echo -e "${GREEN}✅ Catclip updated successfully!${NC}"
    echo "Reload your shell to use the latest version: ${BLUE}source ~/.zshrc${NC}"
else
    echo ""
    echo -e "${GREEN}${BOLD}✨ Catclip installed successfully!${NC}"
    echo ""
    echo -e "${BOLD}Quick Start:${NC}"
    echo -e "  1. Reload your shell: ${BLUE}source ~/.zshrc${NC}"
    echo -e "  2. Try copying a file: ${BLUE}catclip README.md${NC}"
    echo -e "  3. View clipboard: ${BLUE}clipshow${NC}"
    echo -e "  4. See insights: ${BLUE}catclip --insights${NC}"
    echo ""
    echo -e "${BOLD}Commands:${NC}"
    echo -e "  ${BLUE}catclip <file>${NC}     - Copy file(s) to clipboard"
    echo -e "  ${BLUE}catclipl <file>${NC}    - Copy with line numbers"
    echo -e "  ${BLUE}catclips <file>${NC}    - Copy and show on screen"  
    echo -e "  ${BLUE}catclipn <file> <start> <end>${NC} - Copy line range"
    echo -e "  ${BLUE}pwdclip${NC}            - Copy current path"
    echo -e "  ${BLUE}lsclip${NC}             - Copy directory listing"
    echo -e "  ${BLUE}clipshow${NC}           - Show clipboard contents"
    echo ""
    echo -e "${BOLD}Advanced Features:${NC}"
    echo -e "  ${BLUE}catclip --help${NC}     - Show detailed help"
    echo -e "  ${BLUE}catclip --insights${NC} - View usage analytics"
    echo -e "  ${BLUE}catclip --config${NC}   - Configure settings"
    echo ""
    echo -e "${BOLD}80-20 Philosophy:${NC}"
    echo -e "  🤖 80% Computer: Automatic detection, smart handling, insights"
    echo -e "  🧠 20% Human: Your conscious choices about what to copy"
    echo ""
    echo -e "  Learn more: ${BLUE}https://github.com/80-20-Human-In-The-Loop/Community${NC}"
    echo ""
    echo -e "Happy clipping! 🐱📋"
fi