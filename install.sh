#!/bin/sh
set -eu

cd "$(dirname "$0")"

if [ "$(pwd -P)" != "$(cd "$HOME/.dotfiles" 2> /dev/null && pwd -P)" ]; then
  if [ -e "$HOME/.dotfiles" ] && [ ! -L "$HOME/.dotfiles" ]; then
    echo "~/.dotfiles already exists and is a different directory" >&2

    exit 1
  fi

  ln -sfn "$PWD" "$HOME/.dotfiles"
fi

export PATH="$HOME/.local/bin:$PATH"

if ! command -v mise > /dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi

if [ -n "${CODESPACES:-}${CODER:-}" ]; then
  set -- --yes --force-dotfiles "$@"
fi

MISE_GLOBAL_CONFIG_FILE="$HOME/.dotfiles/config/mise/config.toml" mise bootstrap "$@"
