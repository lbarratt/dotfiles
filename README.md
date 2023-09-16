### Luke Barratt's dotfiles

## Installation

Clone this repo

    git clone git://github.com/lbarratt/dotfiles ~/.dotfiles && cd ~/.dotfiles

Install the Homebrew bundle

    brew tap Homebrew/bundle && brew bundle

Switch shells to ZSH

    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
    chsh -s /usr/local/bin/zsh

Symlink the dotfiles

    git submodule init && git submodule update --recursive && rake install

Install TPM

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Install Alacritty theme

    git clone https://github.com/catppuccin/alacritty.git ~/.config/alacritty/catppuccin

Install virtualenv

    pip3 install virtualenv
