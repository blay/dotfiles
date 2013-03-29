# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="dstufft"

# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Shell

export EDITOR="mvim -v"

alias zshconfig="vim ~/.zshrc"
alias zshsource="source ~/.zshrc"

alias rm="rm -i"
alias mv="mv -i"

alias irc='sh ~/scripts/shell/irc'
alias ta2='ssh -t magnus@129.16.157.66 "screen -rd"'
alias www='ssh -t monki@blay.se "cd www"'
alias you='python ~/scripts/shell/youtube-dl -t'
alias yoump3='python ~/scripts/shell/youtube-dl -t -x --audio-format mp3 --audio-quality 0'
alias uppa='sh ~/scripts/shell/uppa'

alias cpu='top -o cpu -n 5'

alias vim='mvim -v'
alias v='mvim -v'


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

# Todo

alias plus='sh ~/scripts/todo/plus.sh'
alias minus='sh ~/scripts/todo/minus.sh'

PATH=$PATH:"/Users/svartfax/scripts/todo/"
alias t='todo.sh -d ~/scripts/todo/todo.cfg'
alias ts='todo.sh -d ~/scripts/todo/todo.cfg schedule'
alias tb='todo.sh -d ~/scripts/todo/todo.cfg birdseye'
alias tu='todo.sh -d ~/scripts/todo/todo.cfg until'
alias tx='todo.sh -x -d ~/scripts/todo/todo.cfg'
alias tv='todo.sh -x -d ~/scripts/todo/todo.cfg view'
alias tt='todo.sh -x -d ~/scripts/todo/todo.cfg view tomorrow'
alias t1='todo.sh -x -d ~/scripts/todo/todo.cfg view 1weeks'
function tm { t schedule $1 mv tomorrow; }
export TODOTXT_DEFAULT_ACTION=ls
export TODOTXT_HOME=/Users/svartfax/scripts/todo
# source /Users/svartfax/scripts/todo/todo_completion
# complete -F _todo t

alias p='python ~/scripts/todo/Punch.py'
n() {
	    echo $(date "+%Y%m%dT%H%M%S => ") "$@" | tee -a ~/Dropbox/todo/notes.txt
	}

# Weird Shit

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

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

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/opt/local/bin:/opt/local/sbin:/Users/svartfax/.rvm/gems/ruby-1.9.2-p320/bin:/Users/svartfax/.rvm/gems/ruby-1.9.2-p320@global/bin:/Users/svartfax/.rvm/rubies/ruby-1.9.2-p320/bin:/Users/svartfax/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/X11/bin:/usr/local/git/bin:/usr/local/MacGPG2/bin:/usr/texbin:/opt/local/bin:/Users/svartfax/scripts/todo/
