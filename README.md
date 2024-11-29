### Luke Barratt's dotfiles

## Installation

Clone this repo

    git clone https://github.com/lbarratt/dotfiles.git ~/.dotfiles && cd ~/.dotfiles

Install the Homebrew bundle

    brew tap Homebrew/bundle && brew bundle

Symlink the dotfiles

    git submodule init && git submodule update --recursive && rake install

Setup Antibody

    antidote bundle <~/.zsh_plugins.txt >~/.zsh_plugins.zsh

Install TPM

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/scripts/install_plugins.sh

Install Alacritty theme

    curl -LO --output-dir ~/.dotfiles/config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml

Install virtualenv

    pip3 install virtualenv

Install [Meslo Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo)
