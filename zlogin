if [[ -f ~/.current_path~ ]]; then
  cd `cat ~/.current_path~`

  rm ~/.current_path~
fi
