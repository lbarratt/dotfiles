# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

# oh-my-zsh config
source $ZSH/oh-my-zsh.sh

# Bunch of path crap, needs cleaning:
# Homebrew
# RVM
# NPM
# PHP
PATH=/usr/local/bin:$HOME/.rvm/bin:$HOME/.bin:/usr/local/share/npm/bin:/usr/local/php5/bin:$HOME/pear/bin:$PATH

# # This loads RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Can't remember why this is here, but PG works
export PGHOST=localhost

# Show contents of directory after cd-ing into it
# (idea yanked from Ben Orenstein's dotfiles)
chpwd() {
  ls -lrthG
}

# Source custom files after oh-my-zsh to override things.
source $HOME/.dotfiles/zsh/aliases