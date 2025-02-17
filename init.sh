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
    colima \
    wget \
    uv \
    pyenv \
    brewsci/bio/pymol \
    tree \
    direnv \

fi
