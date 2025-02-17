#!/bin/bash

set -euo pipefail

if [[ $OSTYPE == 'darwin'* ]]; then
  echo 'macOS'
  brew install stow \
    npm \
    fzf fd ripgrep lazygit \
    alacritty \
    neovim \
    notion \
    tmux \
    nerd-font \
    font-inconsolata-nerd-font \
    colima \
    wget \
    uv \
    pyenv \
    brewsci/bio/pymol \
    tree \
    direnv
fi
