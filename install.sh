#!/bin/sh
set -eu

cd "$(dirname "$0")"

if [ "$PWD" != "$HOME/.dotfiles" ]; then
  echo "This repository must be cloned to ~/.dotfiles" >&2

  exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

if ! command -v mise > /dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi

MISE_GLOBAL_CONFIG_FILE="$PWD/config/mise/config.toml" mise bootstrap "$@"
