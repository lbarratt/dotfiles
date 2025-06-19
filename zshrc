## ZSH Options

unsetopt correct_all

## Environment

PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:$PATH

# Insatiable watchman

ulimit -n 12288

## Antidote ZSH Plugin Manager

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

antidote load

source ~/.zsh_plugins.zsh

## FZF ctrl+r

source <(fzf --zsh)

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

# FNM - Fast Node Manager - (https://github.com/Schniz/fnm)

FNM_PATH="$HOME/.fnm"

if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.fnm:$PATH"

  echo "paff"

  eval "`fnm env`"
fi

# Run this once, then comment out
# fnm completions --shell=zsh > ~/.config/zsh/completions/_fnm 

fpath+=~/.config/zsh/completions/_fnm

autoload -U compinit

compinit

autoload -U add-zsh-hook

# place default node version under $HOME/.node-version
load-nvmrc() {
  DEFAULT_NODE_VERSION="22"

  if [[ -f .nvmrc && -r .nvmrc ]] || [[ -f .node-version && -r .node-version ]]; then
    fnm use
  elif [[ `node -v` != $DEFAULT_NODE_VERSION ]]; then

    echo Reverting to node from "`node -v`" to "$DEFAULT_NODE_VERSION"

    fnm use $DEFAULT_NODE_VERSION
  fi
}

add-zsh-hook chpwd load-nvmrc

load-nvmrc

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

# Rustup

. "$HOME/.cargo/env"

# Go

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$HOME/.local/bin:$PATH

# Clear

clear
