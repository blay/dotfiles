# load zgen
source "${HOME}/.zgen/zgen.zsh"
# if the init script doesn't exist
if ! zgen saved; then

# Load oh-my-zsh base and plugins
zgen oh-my-zsh
zgen oh-my-zsh plugins/git
zgen oh-my-zsh plugins/command-not-found

# Load Github Plugins
zgen load zsh-users/zsh-autosuggestions
zgen load zsh-users/zsh-syntax-highlighting
zgen load zsh-users/zsh-completions
# Load theme
zgen oh-my-zsh themes/steeef


  # generate the init script from plugins above
  zgen save
fi

# Load custom aliases
[[ -s "$HOME/.aliases" ]] && source "$HOME/.aliases"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
