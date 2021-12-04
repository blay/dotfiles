# OSX antigen file
source ~/bin/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh
# Load the theme
antigen theme spaceship-prompt/spaceship-prompt

# Plugins
antigen bundle git
antigen bundle command-not-found
antigen bundle compleat
antigen bundle macos
antigen bundle z
#antigen bundle Aloxaf/fzf-tab
antigen bundle clvv/fasd
#antigen bundle b4b4r07/enhancd
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Tell Antigen that you're done.
antigen apply

# Load custom aliases
[[ -s "$HOME/.aliases" ]] && source "$HOME/.aliases"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
