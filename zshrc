# Start Profiling

export PROFILING_MODE=0

if [ $PROFILING_MODE -ne 0 ]; then
    zmodload zsh/zprof

    zsh_start_time=$(gdate +%s%3N)
fi

# Compile zsh file, and source them. Initial run is slower.

zsource() {
  local file=$1

  # Skip zcompile for non-regular files (e.g. process substitution /dev/fd/...)
  if [[ ! -f "$file" || "$file" == /dev/* || "$file" == /proc/* ]]; then
    source "$file"

    return
  fi

  local zwc="${file}.zwc"

  if [[ ! -f "$zwc" || "$file" -nt "$zwc" ]]; then
    zcompile "$file"
  fi

  source "$file"
}

## ZSH Options

unsetopt correct_all

# Required for prompt command substitution — normally set by OMZ lib/theme-and-appearance.zsh
setopt prompt_subst

# Skip OMZ's compinit — we run it ourselves later
skip_global_compinit=1

## Environment

PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:$PATH

## Completion (must run before plugins that call compdef)

autoload -Uz compinit

ZSH_COMPDUMP="$HOME/.zcompdump"

compinit -C -d "$ZSH_COMPDUMP"

## Antidote ZSH Plugin Manager (static loading)

# Pre-set $ZSH so use-omz skips its `antidote path ohmyzsh/ohmyzsh` subprocess call
export ZSH="$HOME/Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh"

# Only source antidote when the static plugin file needs regenerating
if [[ ! -f ~/.zsh_plugins.zsh || ~/.zsh_plugins.txt -nt ~/.zsh_plugins.zsh ]]; then
  source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

  antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
fi

zsource ~/.zsh_plugins.zsh

# GPG agent — local replacement for ohmyzsh/ohmyzsh path:plugins/gpg-agent.
# The OMZ version runs `gpgconf --list-options gpg-agent` on every shell start (~45ms).
# Our version skips that subprocess since enable-ssh-support is not enabled.
zsource $HOME/.dotfiles/zsh/gpg-agent.zsh

## FZF ctrl+r (cached)

FZF_CACHE="$HOME/.fzf-init.zsh"

if [[ ! -f "$FZF_CACHE" ]]; then
  fzf --zsh > "$FZF_CACHE"
fi

zsource "$FZF_CACHE"

## Text Editor

export EDITOR=nvim

## Aliases

zsource $HOME/.dotfiles/zsh/aliases

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

  eval "`fnm env`"
fi

# Run this once, then comment out
# fnm completions --shell=zsh > ~/.config/zsh/completions/_fnm

fpath+=~/.config/zsh/completions/_fnm

autoload -U add-zsh-hook

# place default node version under $HOME/.node-version
load-nvmrc() {
  DEFAULT_NODE_VERSION="22"

  if [[ -f .nvmrc && -r .nvmrc ]] || [[ -f .node-version && -r .node-version ]]; then
    fnm use --silent-if-unchanged
  else
    fnm use $DEFAULT_NODE_VERSION --silent-if-unchanged
  fi
}

add-zsh-hook chpwd load-nvmrc

# Only run load-nvmrc at startup if we're actually in a project directory;
# otherwise the chpwd hook will handle it on first cd.
if [[ -f .nvmrc || -f .node-version ]]; then
  load-nvmrc
fi

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

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rustup

. "$HOME/.cargo/env"

# Go

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$HOME/.local/bin:$PATH

# Yarn Switch
# source "~/.yarn/switch/env"

# pyenv
#
# Initial setup:
#
# ln -sf "$PYENV_ROOT/shims/python"  ~/.local/bin/python
# ln -sf "$PYENV_ROOT/shims/pip"     ~/.local/bin/pip
# ln -sf "$PYENV_ROOT/shims/python3" ~/.local/bin/python3
# ln -sf "$PYENV_ROOT/shims/pip3"    ~/.local/bin/pip3

export PYENV_ROOT="$HOME/.pyenv"

pyenv() {
  unset -f pyenv

  eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"

  pyenv "$@"
}

# NX

export NX_TUI=false

# Secrets

source ~/.secrets

# End Profiling

if [ $PROFILING_MODE -ne 0 ]; then
    zsh_end_time=$(gdate +%s%3N)

    zprof

    echo "Shell init time: $((zsh_end_time - zsh_start_time)) ms"
fi
