#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if directory exists
directory_exists() {
    [[ -d "$1" ]]
}

# Check if file exists
file_exists() {
    [[ -f "$1" ]]
}

install_fonts() {
    log_info "Installing Nerd Fonts..."
    
    # Check if fonts are already installed
    if fc-list | grep -q "Nerd Fonts" 2>/dev/null; then
        log_success "Nerd Fonts already installed, skipping..."
        return 0
    fi

    declare -a fonts=(
        BitstreamVeraSansMono
        CodeNewRoman
        DroidSansMono
        FiraCode
        FiraMono
        Go-Mono
        Hack
        Hermit
        JetBrainsMono
        Meslo
        Noto
        Overpass
        ProggyClean
        RobotoMono
        SourceCodePro
        SpaceMono
        Ubuntu
        UbuntuMono
    )

    version='3.4.0'
    fonts_dir="${HOME}/.local/share/fonts"

    if [[ ! -d "$fonts_dir" ]]; then
        mkdir -p "$fonts_dir"
    fi

    for font in "${fonts[@]}"; do
        zip_file="${font}.zip"
        download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
        log_info "Downloading $font..."
        wget -q "$download_url"
        unzip -q "$zip_file" -d "$fonts_dir"
        rm "$zip_file"
    done

    find "$fonts_dir" -name '*Windows Compatible*' -delete

    fc-cache -fv >/dev/null 2>&1
    log_success "Nerd Fonts installed successfully!"
}

install_nvm() {
    log_info "Installing NVM..."
    
    if command_exists nvm; then
        log_success "NVM already installed, skipping..."
        return 0
    fi

    if [[ ! -f "${HOME}/.nvm/nvm.sh" ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
        log_success "NVM installed successfully!"
    else
        log_success "NVM already installed, skipping..."
    fi
}

install_lazygit() {
    log_info "Installing lazygit..."
    
    if command_exists lazygit; then
        log_success "lazygit already installed, skipping..."
        return 0
    fi

    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm lazygit.tar.gz lazygit
    log_success "lazygit installed successfully!"
}

install_uv() {
    log_info "Installing uv..."
    
    if command_exists uv; then
        log_success "uv already installed, skipping..."
        return 0
    fi

    curl -LsSf https://astral.sh/uv/install.sh | sh
    log_success "uv installed successfully!"
}

install_apt_deps() {
    log_info "Installing APT dependencies..."
    
    # Check if all packages are already installed
    local packages=("stow" "fzf" "fd-find" "ripgrep" "alacritty" "tmux" "docker" "wget" "tree" "direnv" "zoxide" "npm")
    local missing_packages=()
    
    for package in "${packages[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            missing_packages+=("$package")
        fi
    done
    
    if [[ ${#missing_packages[@]} -eq 0 ]]; then
        log_success "All APT dependencies already installed, skipping..."
        return 0
    fi
    
    log_info "Installing missing packages: ${missing_packages[*]}"
    sudo apt update
    sudo apt install -y "${missing_packages[@]}"
    log_success "APT dependencies installed successfully!"
}

install_neovim() {
    log_info "Installing Neovim..."
    
    if command_exists nvim; then
        log_success "Neovim already installed, skipping..."
        return 0
    fi

    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
    
    # Add to PATH if not already there
    if ! grep -q "/opt/nvim-linux-x86_64/bin" ~/.zshrc 2>/dev/null; then
        echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >>~/.zshrc
    fi
    
    log_success "Neovim installed successfully!"
}

install_tpm() {
    log_info "Installing Tmux Plugin Manager..."
    
    if directory_exists ~/.tmux/plugins/tpm; then
        log_success "TPM already installed, skipping..."
        return 0
    fi

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    log_success "TPM installed successfully!"
}

install_lazyvim() {
    log_info "Installing LazyVim..."
    
    if directory_exists ~/.config/nvim; then
        log_warning "~/.config/nvim already exists. Backing up to ~/.config/nvim.bak"
        mv ~/.config/nvim ~/.config/nvim.bak
    fi

    git clone git@github.com:jofa974/lazyvim.git ~/.config/nvim
    log_success "LazyVim installed successfully!"
}

install_google_cloud_cli() {
    log_info "Installing Google Cloud CLI..."
    
    if command_exists gcloud; then
        log_success "Google Cloud CLI already installed, skipping..."
        return 0
    fi

    if [[ ! -f "google-cloud-cli-linux-x86_64.tar.gz" ]]; then
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
    fi
    
    if [[ ! -d "./google-cloud-sdk" ]]; then
        tar -xf google-cloud-cli-linux-x86_64.tar.gz
    fi
    
    ./google-cloud-sdk/install.sh --quiet
    log_success "Google Cloud CLI installed successfully!"
}

install_zsh() {
    log_info "Installing Zsh..."
    
    if command_exists zsh; then
        log_success "Zsh already installed, skipping..."
        return 0
    fi

    sudo apt install -y zsh
    log_success "Zsh installed successfully!"
}

install_oh_my_zsh() {
    log_info "Installing Oh My Zsh..."
    
    if directory_exists ~/.oh-my-zsh; then
        log_success "Oh My Zsh already installed, skipping..."
        return 0
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed successfully!"
}

# Main function to run all installations
run_all() {
    log_info "Starting complete environment setup..."
    
    install_zsh
    install_oh_my_zsh
    install_fonts
    install_nvm
    install_lazygit
    install_uv
    install_apt_deps
    install_neovim
    install_tpm
    install_lazyvim
    install_google_cloud_cli
    
    log_success "Environment setup completed!"
    log_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  all                    Install all components"
    echo "  fonts                  Install Nerd Fonts"
    echo "  nvm                    Install Node Version Manager"
    echo "  lazygit                Install lazygit"
    echo "  uv                     Install uv package manager"
    echo "  apt-deps               Install APT dependencies"
    echo "  neovim                 Install Neovim"
    echo "  tpm                    Install Tmux Plugin Manager"
    echo "  lazyvim                Install LazyVim configuration"
    echo "  gcloud                 Install Google Cloud CLI"
    echo "  zsh                    Install Zsh"
    echo "  oh-my-zsh              Install Oh My Zsh"
    echo "  help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 all                 # Install everything"
    echo "  $0 neovim              # Install only Neovim"
    echo "  $0 fonts apt-deps      # Install fonts and APT dependencies"
}

# Main script logic
main() {
    if [[ $# -eq 0 ]]; then
        log_warning "No arguments provided. Running complete setup..."
        run_all
        return 0
    fi

    case "$1" in
        "all")
            run_all
            ;;
        "fonts")
            install_fonts
            ;;
        "nvm")
            install_nvm
            ;;
        "lazygit")
            install_lazygit
            ;;
        "uv")
            install_uv
            ;;
        "apt-deps")
            install_apt_deps
            ;;
        "neovim")
            install_neovim
            ;;
        "tpm")
            install_tpm
            ;;
        "lazyvim")
            install_lazyvim
            ;;
        "gcloud")
            install_google_cloud_cli
            ;;
        "zsh")
            install_zsh
            ;;
        "oh-my-zsh")
            install_oh_my_zsh
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
