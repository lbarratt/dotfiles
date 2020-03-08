## ZSH Options

unsetopt correct_all

## Environment

# $PATH Additions:
# - Homebrew
# - NPM
PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH

## Antigen ZSH Plugin Manager

source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle heroku
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme candy

antigen apply

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

# GPG

if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
  source ~/.gnupg/.gpg-agent-info
  export GPG_AGENT_INFO
else
  eval $(gpg-agent --daemon)
fi

export GPG_TTY=$(tty)

## Programming Language Speicic

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

