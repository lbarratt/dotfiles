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

# Required for prompt command substitution. Usually set by OMZ.
setopt prompt_subst

# Skip OMZ compinit. We run this manually later.
skip_global_compinit=1

## Environment

PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:/opt/homebrew/bin:$PATH

## Antidote ZSH Plugin Manager (static loading)

# Resolve git status async
zstyle ':omz:alpha:lib:git' async-prompt yes

# antidote updates oh-my-zsh
zstyle ':omz:update' mode disabled

# Avoid use-omz running `scutil` to compute these.
SHORT_HOST=${HOST%%.*}
ZSH_COMPDUMP="$HOME/.zcompdump"

# Only source antidote when the static plugin files require regeneration.
#
# When antidote is not loaded, use-omz looks for $ZSH without a subprocess.
if [[ ! -f ~/.zsh_plugins.zsh || ~/.zsh_plugins.txt -nt ~/.zsh_plugins.zsh ]]; then
  source ~/.antidote/antidote.zsh && antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
fi

zsource ~/.zsh_plugins.zsh

## Completion. 

# This runs after plugins so that it observers fpath entries. It replays 
# compdef calls that use-omz queues. 
#
# Without this, use-omz runs a slower compinit before the first prompt (~20ms).

autoload -Uz compinit

compinit -C -d "$ZSH_COMPDUMP"

# GPG agent. Local replacement for ohmyzsh/ohmyzsh path:plugins/gpg-agent.
#
# OMZ runs `gpgconf --list-options gpg-agent` on every shell (~45ms).
#
# This version skips the subprocess since enable-ssh-support is not enabled.
zsource $HOME/.dotfiles/zsh/gpg-agent.zsh

## Text Editor

export EDITOR=nvim

## Aliases

zsource $HOME/.dotfiles/zsh/aliases

## Tooling

# Python

export PATH=$PATH:$HOME/.local/bin

# Android Studio

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# bun

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Go

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$HOME/.local/bin:$PATH

# pnpm

if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# mise (https://mise.jdx.dev)
#
# Handles command line tools installation.
#
# Configuration is located at: config/mise/config.toml
(( $+commands[mise] )) && eval "$(mise activate zsh)"

## FZF ctrl+r.

FZF_CACHE="$HOME/.fzf-init.zsh"

if [[ ! -f "$FZF_CACHE" ]]; then
  fzf --zsh > "$FZF_CACHE"
fi

zsource "$FZF_CACHE"

# Secrets

[[ -f ~/.secrets ]] && source ~/.secrets

# End Profiling

if [ $PROFILING_MODE -ne 0 ]; then
    zsh_end_time=$(gdate +%s%3N)

    zprof

    echo "Shell init time: $((zsh_end_time - zsh_start_time)) ms"
fi
