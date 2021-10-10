# OSX antigen file
source /opt/homebrew/share/antigen/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh
# Load the theme
antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

# Plugins
antigen bundle git
antigen bundle command-not-found
antigen bundle compleat
antigen bundle osx
antigen bundle z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle clvv/fasd
antigen bundle b4b4r07/enhancd
#antigen bundle junegunn/fzf
antigen bundle Aloxaf/fzf-tab

# Tell Antigen that you're done.
antigen apply

# Setup zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load custom aliases
[[ -s "$HOME/.aliases" ]] && source "$HOME/.aliases"
