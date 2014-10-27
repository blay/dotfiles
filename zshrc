# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="dstufft"

# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Autocomplete

autoload -U compinit
compinit

fpath=(~/.rvm/gems/ruby-2.1.2/gems/timetrap-1.8.14/completions/zsh $fpath)

# Shell

USER='svartfax'

# Preferred editor for local and remote sessions
if [[ $(uname) == Linux ]]; then
  export EDITOR='vim'
  HARDHOME='home'
 else
  export EDITOR='mvim -v'
  alias vim='mvim -v'
  HARDHOME='Users'
  alias grep="ggrep"
fi

alias zshconfig="vim ~/.zshrc"
alias zshsource="source ~/.zshrc"

alias rm="rm -i"
alias mv="mv -i"

alias uppa='sh ~/.shell/uppa'

alias cpu='top -o cpu -n 5'

alias solve='sh ~/.shell/solve'

# Blog
alias newo='sh ~/scripts/blog/newocto'
alias new='sh ~/scripts/blog/new'
alias pre='sh ~/scripts/blog/pre'
alias news='sh ~/scripts/blog/news'
alias edits='sh ~/scripts/blog/edits'
alias edit='sh ~/scripts/blog/edit'
alias pre='sh ~/scripts/blog/pre'
alias edito='sh ~/scripts/blog/editocto'
alias pubo='sh ~/scripts/blog/pubocto'
alias preo='sh ~/scripts/blog/preocto'

alias gitta='sh ~/scripts/blog/gitta'

# Move t out of the way
alias tt='~/.rvm/gems/ruby-2.1.2/bin/t'

# Todo

## Commands
alias plus='sh ~/.shell/plus.sh'
alias minus='sh ~/.shell/minus.sh'

PATH=$PATH:"/$HARDHOME/$USER/.todo"
alias t='todo.sh -d ~/.todo.cfg'
alias ts='todo.sh -d ~/.todo.cfg schedule'
alias tbw="(t birdseye;echo '\n# Scheduled next week #\n----------------------------';tv 1weeks;echo '\n# Due Soon #\n------------';t until soon)"
alias tbm="(t birdseye;echo '\n# Scheduled next 3 weeks #\n----------------------------';tv 3weeks;echo '\n# Due Soon #\n------------';t until soon;echo '\n# No Dates #\n------------';tv nodate;)"
alias tu='todo.sh -d ~/.todo.cfg until'
alias tx='todo.sh -x -d ~/.todo.cfg'
alias tv='todo.sh -x -d ~/.todo.cfg view'
alias t1='(tv past;tv today)'
alias t7='todo.sh -x -d ~/.todo.cfg view 1weeks'
alias te='vim ~/Dropbox/todo/todo.txt'
alias tc='clear && todo.sh -d ~/.todo.cfg'
function tm { t schedule $1 mv tomorrow; }

## Fix

alias tfix='todo.sh -d ~/.todofix.cfg'

## Defaults

export TODOTXT_DEFAULT_ACTION=ls
export TODOTXT_HOME=/$HARDHOME/$USER/.todo
# source /$HARDHOME/$USER/.todo/todo_completion
# complete -F _todo t

alias p='python ~/.todo/Punch.py'
n() {
	    echo $(date "+%Y%m%dT%H%M%S => ") "$@" | tee -a ~/Dropbox/todo/notes.txt
	}

# Common cd

alias cdn='cd ~/notes/simplenotes'
alias cdsh='cd ~/.shell'

# Emacs

alias weekly='sh ~/.shell/weekly'
alias yearly='sh ~/.shell/yearly'
# Weird Shit

export GPG_TTY=`tty`

# Se tto this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

unsetopt nomatch

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx last-working-dir sublime)

PATH=$PATH:"/usr/local/sbin"

# Ensure user-installed binaries take precedence
# export PATH=/usr/local/bin:$PATH

source $ZSH/oh-my-zsh.sh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$HOME/.shell:$PATH" # Add scripts to path
