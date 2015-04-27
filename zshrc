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

# PATH STUFF
# Homebrew
# NPM
# Postgres.app
PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:/Applications/Postgres93.app/Contents/MacOS/bin:/usr/local/share/npm/bin:$PATH

# rbenv - https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x
export RBENV_ROOT=/usr/local/var/rbenv
eval "$(rbenv init -)"

# Can't remember why this is here, but PG works
export PGHOST=localhost

# Source custom files after oh-my-zsh to override things.
source $HOME/.dotfiles/zsh/aliases

# Show contents of directory after cd-ing into it
# (idea yanked from Ben Orenstein's dotfiles)
chpwd() {
  l
}

# Disable autocorrect
unsetopt correct_all

# Docker
$(boot2docker shellinit)
