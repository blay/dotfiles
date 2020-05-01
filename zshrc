# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="dstufft"
#ZSH_THEME="spaceship"
#ZSH_THEME="avit"
#ZSH_THEME="arrow"
#ZSH_THEME="hyperzsh"
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Autocomplete

autoload -U compinit
compinit

# Shell

USER='svartfax'

# Preferred editor for local and remote sessions
if [[ $(uname) == Linux ]]; then
  export EDITOR='vim'
  HARDHOME='home'
  alias pbcopy='xclip -selection c'
  alias pbpaste='xclip -o'
  alias vim='nvim'
#  alias ack='ack-grep'
 else
  export EDITOR='mvim -v'
  alias vim='mvim -v'
  HARDHOME='Users'
  alias grep="ggrep"
fi

alias zc="vim ~/.zshrc"
alias zshconfig="vim ~/.zshrc"
alias zs="source ~/.zshrc"
alias zshsource="source ~/.zshrc"

alias svim="sudo -E nvim"
alias em="emacsclient -a '' -qc"
alias ema="emacsclient -a '' -qc -e '(org-agenda)'"
alias nv="nvim"

alias rm="rm -i"
alias mv="mv -i"

alias c="clear"

alias uppa='sh ~/.shell/uppa'

alias cpu='top -o cpu -n 5'

alias px='ps aux|a'

alias solve='sh ~/.shell/solve'

alias in='insect'

alias scr='screen -rd'

alias 1024='sips -Z 1024 *.jpg'

alias jab="wmname LG3D"

alias mp3='youtube-dl -x --audio-format "mp3"'

alias cal="ncal -w"

alias fucking="sudo"

alias freq="history | cut -c 8- | sort | uniq -c  | sort -n -r | head -n 20"

alias vpn="nmcli con up client"

# Zettel

co() {

	fc -e -|tail -n${@:-1}|head -n1|cut -f 1 -d " "|tr -d "\n"|pbcopy
}

alias a="ag"
alias af="ag -g"
alias al="a -l"
alias ax="ack -x"
alias ap="ag --passthru"
alias aq="ag -Q"
alias az="ag -l | fzf"
alias av="ag --nobreak --nonumbers --noheading . | fzf" 
alias auid="xargs -i ag -g {}"
alias aorphan="af (N-|T-|W-|O-)|ax -L [0-9]{12}|ax -L '(?<=\@)[a-z]*[0-9]{4}'"

alias fd=fdfind
alias f="find . -type f -not -path '*/\.*'"
alias lt='ls -lhtr | tr -s " " | cut -d " " -f6-'
alias rnd='ls|sort -R' 

alias am='ag --passthru  "^\#.*"'

alias pan='make -f ~/.pandoc/examples/Makefile'

alias zkviz='~/envs/zkviz/bin/zkviz'

# Google Calendar

alias ca="date;gcalcli agenda"
alias cw="gcalcli calw --monday"
alias cm="gcalcli calm --monday"
alias cq="gcalcli --cal Kalender quick"
alias cr="gcalcli --cal RISE quick"
alias cx="gcalcli --cal Deadlines quick"

# Weather

alias wtr="curl wttr.in"

# workout
alias logbook="cat ~/notes/workout/logbook.md"
alias logedit='vim ~/notes/workout/logbook.md'


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

alias gitta='git commit -v -a -m'

# Todo

alias tt='rg @todo:a ~/zettel'
alias tb='rg @todo:b ~/zettel'
alias tc='rg @todo:c ~/zettel'

# Git
alias gitdone='git log -p -1|ag @todo:|ap "^-"'

## Commands
alias plus='sh ~/.shell/plus.sh'
alias minus='sh ~/.shell/minus.sh'

# PATH=$PATH:"/$HARDHOME/$USER/.todo"
alias t='todo.sh -d ~/.todo.cfg'
alias ts='todo.sh -d ~/.todo.cfg schedule'
alias tbw="(t birdseye;echo '\n# Scheduled next week #\n----------------------------';tv 1weeks;echo '\n# Due Soon #\n------------';t until soon;echo '\n# No Dates #\n------------';tv nodate;)"
alias tbm="(t birdseye;echo '\n# Scheduled next 3 weeks #\n----------------------------';tv 3weeks;cal;echo '\n';icf;echo '\n# Due Soon #\n------------';t until soon;echo '\n# No Dates #\n------------';tv nodate;)"
alias tu='todo.sh -d ~/.todo.cfg until'
alias tx='todo.sh -x -d ~/.todo.cfg'
alias tv='todo.sh -x -d ~/.todo.cfg view'
alias t1='(tv past;tv today)'
alias t7='todo.sh -x -d ~/.todo.cfg view 1weeks'
alias te='vim ~/Dropbox/todo/todo.txt'
alias tn='clear && (tv past;tv today)'
alias tf='clear && (tv past;tv today;tv future)'
function tm { ts $1 mv tomorrow; }

## Fix

alias tfix='todo.sh -x -d ~/.todofix.cfg'
alias tfixc='tfix view context'
alias tfixe='vim ~/Dropbox/todo/todofix.txt'

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

alias cdn='cd ~/zettel'
alias cdo='cd ~/notes/org'
alias cdsh='cd ~/.shell'
alias cdxi='cd ~/notes/omxi.se'
alias cdd='cd ~/Downloads'
alias cdv='cd ~/Videos'
alias cdm='cd ~/Music'
alias cdw='cd ~/wallpapers'
alias cdb='cd ~/builds'
alias cdp='~/papers'
alias rn='ranger'

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
plugins=(git osx last-working-dir sublime colorize)


# Ensure user-installed binaries take precedence
# export PATH=/usr/local/bin:$PATH

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.shell:$PATH" # Add scripts to path
export PATH="$HOME/.local/bin:$PATH" # Add pip scripts to path
export LESS=-RFX
export GEM_HOME=$HOME/bin/gems
export PATH=$HOME/bin/gems/bin:$PATH
export PATH=$HOME/bin/go/bin:$PATH
export PATH=$HOME/bin/:$PATH

# Golang
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Fuck Android
#export STUDIO_JDK=/Library/Java/JavaVirtualMachines/jdk1.8.0_51.jdk
#export ANDROID_HOME=/usr/local/opt/android-sdk

# WSL shit
#export DISPLAY=:0 
#export XDG_RUNTIME_DIR=~/builds/xdg 
#export RUNLEVEL=3 

# Something to fix Tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte-2.91.sh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type file --color=always --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

