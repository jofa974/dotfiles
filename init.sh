#!/bin/bash

set -euo pipefail
# echo "zsh"
# sudo apt install zsh
# echo "oh my zsh"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
install_fonts () {
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
	    echo "Downloading $download_url"
	    wget "$download_url"
	    unzip "$zip_file" -d "$fonts_dir"
	    rm "$zip_file"
	done

	find "$fonts_dir" -name '*Windows Compatible*' -delete

	fc-cache -fv
}

#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

#source ~/.zshrc
lazygit () {
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit -D -t /usr/local/bin/
}

uv () {
	curl -LsSf https://astral.sh/uv/install.sh | sh
}

#lazygit
#uv

install_apt_deps() {
	sudo apt install stow \
		fzf fd-find ripgrep \
		alacritty \
		tmux \
		docker \
		wget \
		tree \
		direnv \
		zoxide \
		npm
}

neovim () {
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
	echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.zshrc
}
neovim
# install_apt_deps

#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mv ~/.config/nvim{,.bak}
git clone git@github.com:jofa974/lazyvim.git ~/.config/nvim
