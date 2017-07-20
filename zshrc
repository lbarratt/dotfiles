# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/oh-my-zsh

# Functions

# Show contents of directory after cd-ing into it
# (idea yanked from Ben Orenstein's dotfiles)
chpwd() {
  l
}

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

# editor
EDITOR=vim

# PATH STUFF
# Homebrew
# NPM
# Postgres.app
PATH=/usr/local/bin:/usr/local/sbin:$HOME/.bin:/usr/local/share/npm/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH

# Source custom files after oh-my-zsh to override things.
source $HOME/.dotfiles/zsh/aliases

# chruby
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Disable autocorrect
unsetopt correct_all

# NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

autoload -U add-zsh-hook

load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
        nvm use
    fi
}

add-zsh-hook chpwd load-nvmrc

# GPG

if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
   source ~/.gnupg/.gpg-agent-info
   export GPG_AGENT_INFO
else
   eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
fi

# JVM

export JENV_ROOT=/usr/local/opt/jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Mongo
export PATH=$HOME/.mongodb/bin:$PATH

# Cargo/rust
source $HOME/.cargo/env
