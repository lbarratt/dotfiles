## ZSH Options

unsetopt correct_all

## Environment

PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:$PATH

# Insatiable watchman

ulimit -n 12288

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

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm use default

# Cargo/rust

source $HOME/.cargo/env

# Ruby

eval "$(rbenv init - zsh)"

# FZF

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Python

export PATH=$PATH:$HOME/.local/bin

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Android Studio

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# bun

[ -s "/Users/luke/.bun/_bun" ] && source "/Users/luke/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
