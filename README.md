### Luke Barratt's dotfiles

## Installation

Clone this repo to `~/.dotfiles` and run the installer. It works for both macOS and Debian/Ubuntu.

    git clone https://github.com/lbarratt/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh

`install.sh` will install [mise](https://mise.jdx.dev) if it is missing and runs `mise bootstrap`. This applies [config/mise/config.toml](config/mise/config.toml):

- System packages, with apt on Linux and Homebrew formulae and casks on macOS
- Command-line tools
- Language runtimes
- [Antidote](https://antidote.sh)
- Symlinks from `~` and `~/.config`
- zsh

## Commands

Run `install.sh` after any changes. This is idempotent:

    ./install.sh --dry-run
    ./install.sh --yes
    ./install.sh --force-dotfiles

After the first run, configuration is managed by mise:

    mise bootstrap status
    mise upgrade

## Manual steps

Install [Meslo Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo)
