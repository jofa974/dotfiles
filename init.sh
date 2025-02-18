#!/bin/bash

set -euo pipefail
echo "oh my zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if [[ $OSTYPE == 'darwin'* ]]; then
  echo 'macOS'

  brew install --cask font-0xproto-nerd-font

  brew install stow \
    npm \
    fzf fd ripgrep lazygit \
    alacritty \
    neovim \
    notion \
    tmux \
    font-inconsolata-nerd-font \
    docker \
    colima \
    wget \
    uv \
    pyenv \
    pyenv-virtualenv \
    brewsci/bio/pymol \
    tree \
    direnv \
    zoxide
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpmgit clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mv ~/.config/nvim{,.bak}
git clone git@github.com:jofa974/lazyvim.git ~/.config/nvim
