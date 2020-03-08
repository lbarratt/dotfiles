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

EDITOR=nvim

## Aliases

source $HOME/.dotfiles/zsh/aliases

## Functions

# Show contents of directory after cd-ing into it

chpwd() {
  ls -la
}

## Tooling

# Ruby
eval "$(rbenv init -)"

# NVM - Node Version Manager
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

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

alias python=/usr/local/bin/python3

# Google Cloud

source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

