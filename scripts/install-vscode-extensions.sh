#!/bin/bash

# VS Code Extension Installer
# Installs extensions from the extensions.txt file

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
EXTENSIONS_FILE="$DOTFILES_DIR/vscode/extensions.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                    VS Code Extension Installer                  ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
}

check_requirements() {
    # Check if VS Code is installed
    if ! command -v code &> /dev/null; then
        print_error "VS Code 'code' command not found!"
        print_error "Please install VS Code and ensure the 'code' command is in your PATH."
        
        if [[ "$OSTYPE" == "darwin"* ]]; then
            print_warning "On macOS, you may need to:"
            print_warning "1. Open VS Code"
            print_warning "2. Press Cmd+Shift+P"
            print_warning "3. Type 'shell command' and select 'Install code command in PATH'"
        elif grep -qi microsoft /proc/version 2>/dev/null; then
            print_warning "In WSL, make sure VS Code is installed on Windows with WSL extension"
        fi
        
        return 1
    fi
    
    # Check if extensions file exists
    if [[ ! -f "$EXTENSIONS_FILE" ]]; then
        print_error "Extensions file not found: $EXTENSIONS_FILE"
        return 1
    fi
    
    return 0
}

install_extensions() {
    local installed_count=0
    local failed_count=0
    local skipped_count=0
    local total_count=0
    
    print_status "Reading extensions from: $EXTENSIONS_FILE"
    
    while IFS= read -r extension || [[ -n "$extension" ]]; do
        # Skip empty lines and comments
        if [[ -z "$extension" || "$extension" == \#* ]]; then
            continue
        fi
        
        # Remove any whitespace
        extension=$(echo "$extension" | tr -d '[:space:]')
        total_count=$((total_count + 1))
        
        echo -n "Installing $extension... "
        
        # Check if extension is already installed
        if code --list-extensions | grep -qi "^$extension$"; then
            echo -e "${YELLOW}already installed${NC}"
            skipped_count=$((skipped_count + 1))
        else
            # Install the extension
            if code --install-extension "$extension" --force > /dev/null 2>&1; then
                echo -e "${GREEN}✓ installed${NC}"
                installed_count=$((installed_count + 1))
            else
                echo -e "${RED}✗ failed${NC}"
                failed_count=$((failed_count + 1))
            fi
        fi
    done < "$EXTENSIONS_FILE"
    
    # Print summary
    echo ""
    print_status "Extension Installation Summary:"
    echo -e "  ${GREEN}✓ Installed:${NC} $installed_count"
    echo -e "  ${YELLOW}⊝ Skipped:${NC} $skipped_count (already installed)"
    echo -e "  ${RED}✗ Failed:${NC} $failed_count"
    echo -e "  📊 Total: $total_count"
    
    if [[ $failed_count -gt 0 ]]; then
        print_warning "Some extensions failed to install. This might be due to:"
        print_warning "- Network connectivity issues"
        print_warning "- Extension no longer available"
        print_warning "- VS Code needs to be updated"
        return 1
    fi
    
    return 0
}

list_installed_extensions() {
    print_status "Currently installed VS Code extensions:"
    code --list-extensions | sort
}

show_help() {
    echo "VS Code Extension Installer"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -l, --list     List currently installed extensions"
    echo "  -v, --verbose  Enable verbose output"
    echo ""
    echo "This script installs VS Code extensions from:"
    echo "  $EXTENSIONS_FILE"
    echo ""
    echo "Extensions are listed one per line. Comments (lines starting with #) are ignored."
}

# Main execution
main() {
    local verbose=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_installed_extensions
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use -h or --help for usage information"
                exit 1
                ;;
        esac
    done
    
    print_header
    
    # Check requirements
    if ! check_requirements; then
        exit 1
    fi
    
    print_status "VS Code version: $(code --version | head -n1)"
    
    # Install extensions
    if install_extensions; then
        print_status "All extensions installed successfully!"
        echo ""
        print_status "You may need to restart VS Code for some extensions to take effect."
    else
        print_error "Some extensions failed to install."
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi