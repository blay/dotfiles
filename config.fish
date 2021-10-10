# Preferred editor for local and remote sessions
switch (uname)
    case Linux
        set HARDHOME 'home'
        export EDITOR='nvim'
        export VISUAL='nvim'
        alias pbcopy='xclip -selection c'
        alias pbpaste='xclip -o'
        alias vim='nvim'
        alias fd='fdfind'
        export VISUAL='nvim'
    case Darwin
        set HARDHOME 'users'
        export EDITOR='nvim'
        alias vim='nvim'
        alias grep="ggrep"
        alias date="gdate"
        alias sed="gsed"
end

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
alias agenda="sh ~/.shell/agenda"

# Weather

alias wtr="curl wttr.in"

# workout
alias logbook="cat ~/notes/workout/logbook.md"
alias logedit='vim ~/notes/workout/logbook.md'


# Blog
alias bs="bundle exec jekyll serve"
alias bb="bundle exec jekyll build"
alias bp="rsync -havz --delete _site monki@blay.se:www/blay.se/"
#
# Todo

alias tt='rg @todo:a ~/zettel'
alias tb='rg @todo:b ~/zettel'
alias tc='rg @todo:c ~/zettel'

# Git
alias gitta='sh ~/.shell/gitta'
alias gitdone='git log -p -1|ag @todo:|ap "^-"'
alias gitlogs='git log --pretty=format:"%ar : %s"'

## Commands
alias plus='sh ~/.shell/plus.sh'
alias minus='sh ~/.shell/minus.sh'
#
# Common cd

alias k='cd ~/zettel && nv'
alias cdl='cd ~/zettel'
alias cdn='cd ~/notes'
alias cdo="cd ~/notes/org"
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

# Annot2md path
export PATH=~/bin/annot2md/bin:$PATH

export PATH=/Users/svartfax/bin/annot2md/bin:/Users/svartfax/.npm-global/bin:/Users/svartfax/go/bin:/Users/svartfax/bin/:/Users/svartfax/bin/go/bin:/Users/svartfax/bin/gems/bin:/Users/svartfax/.local/bin:/Users/svartfax/.shell:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/Library/Apple/usr/bin:/Users/svartfax/.emacs.d/bin:/Users/svartfax/.fzf/bin:/opt/homebrew/bin/

starship init fish | source
