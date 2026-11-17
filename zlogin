[[ -o interactive ]] || path=($HOME/.local/share/mise/shims $path)

if [[ -f ~/.current_path~ ]]; then
  cd `cat ~/.current_path~`

  rm ~/.current_path~
fi
