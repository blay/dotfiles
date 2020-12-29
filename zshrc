# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Theme


# Shell

USER='svartfax'

# Preferred editor for local and remote sessions
if [[ $(uname) == Linux ]]; then
  export EDITOR='nvim'
  export VISUAL='nvim'
  HARDHOME='home'
  alias pbcopy='xclip -selection c'
  alias pbpaste='xclip -o'
  alias vim='nvim'
  export VISUAL='nvim'
#  alias ack='ack-grep'
 else
  export EDITOR='nvim'
  alias vim='nvim'
  HARDHOME='Users'
  alias grep="ggrep"
  alias date="gdate"
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

alias please="sudo"
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
alias pre='fzf --preview="head -$LINES {}" --preview-window wrap'
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
alias bs="bundle exec jekyll serve"
alias bb="bundle exec jekyll build"
alias bp="rsync -havz --delete _site monki@blay.se:www/blay.se/"
# Todo

alias tt='rg @todo:a ~/zettel'
alias tb='rg @todo:b ~/zettel'
alias tc='rg @todo:c ~/zettel'

# Git
alias gitdone='git log -p -1|ag @todo:|ap "^-"'
alias gitlogs='git log --pretty=format:"%ar : %s"'

gitpush() {
    git add .
    git commit -m "$*"
    git push
}
alias gitta=gitpush


## Commands
alias plus='sh ~/.shell/plus.sh'
alias minus='sh ~/.shell/minus.sh'

# PATH=$PATH:"/$HARDHOME/$USER/.todo"
alias td='todo.sh -d ~/.todo.cfg'
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

alias k='cd ~/zettel && nv'
alias cdl='cd ~/zettel'
alias cdn='cd ~/notes'
alias cdo='cd ~/notes/org'
alias cdsh='cd ~/.shell'
alias cdxi='cd ~/notes/omxi.se'
alias cdx='cd ~/notes/hexo'
alias cdbl='cd ~/notes/blay.se'
alias cdcv='cd ~/notes/cv.blay.se'
alias cdha='cd ~/notes/hack'
alias cdd='cd ~/Downloads'
alias cdv='cd ~/Videos'
alias cdm='cd ~/Music'
alias cdw='cd ~/wallpapers'
alias cdb='cd ~/builds'
alias cdp='~/papers'
alias lib='nvim ~/notes/lib.bib'
alias rn='ranger'

# Emacs

alias weekly='sh ~/.shell/weekly'
alias yearly='sh ~/.shell/yearly'
# Weird Shit

export GPG_TTY=`tty`

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

# Doom Emacs
export PATH=$PATH:~/.emacs.d/bin

# NPM Global
export PATH=~/.npm-global/bin:$PATH

# Completion for kitty
#kitty + complete setup zsh | source /dev/stdin

# Customize to your needs...
source ~/.zplug/init.zsh
# Plugins
zplug "plugins/git",   from:oh-my-zsh
#zplug "plugins/osx",   from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "clvv/fasd"
zplug "b4b4r07/enhancd"
zplug "junegunn/fzf"
zplug "Peltoche/lsd"

autoload -Uz promptinit
promptinit
prompt steeef

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fdfind --type file --color=always --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
