## ZSH Options

unsetopt correct_all

## Environment

# $PATH Additions:
# - Homebrew
# - NPM
PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH

## Antibody ZSH Plugin Manager

autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

source <(antibody init)

antibody bundle < ~/.zsh_plugins


## Text Editor

export EDITOR=nvim

## Aliases

source $HOME/.dotfiles/zsh/aliases

## Functions

# Show contents of directory after cd-ing into it

chpwd() {
  ls -la
}

## Tooling

# NVM - Node Version Manager
export NVM_DIR=~/.nvm
source $NVM_DIR/nvm.sh

autoload -U add-zsh-hook

load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}

add-zsh-hook chpwd load-nvmrc

# Cargo/rust

source $HOME/.cargo/env

## Apps

# MongoDB

export PATH=$HOME/.mongodb/bin:$PATH

# FZF

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Python

export PATH=$PATH:$HOME/.local/bin
