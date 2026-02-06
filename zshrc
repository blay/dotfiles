# Load OS specifics
source "$HOME/.os.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load zgenom
source "${HOME}/.zgenom/zgenom.zsh"
# if the init script doesn't exist
if ! zgenom saved; then

# Load oh-my-zsh base and plugins
zgenom oh-my-zsh
zgenom oh-my-zsh plugins/git
zgenom oh-my-zsh plugins/command-not-found
zgenom oh-my-zsh plugins/history-substring-search
# Load Github Plugins
zgenom load zsh-users/zsh-autosuggestions
zgenom load zsh-users/zsh-syntax-highlighting
zgenom load zsh-users/zsh-completions
zgenom load zsh-users/zsh-interactive-cd
zgenom load joshskidmore/zsh-fzf-history-search
# Load theme
zgenom load romkatv/powerlevel10k powerlevel10k
#zgenom oh-my-zsh themes/steeef


  # generate the init script from plugins above
  zgenom save
fi

# Load custom aliases
[[ -s "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Source FZF
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
[ -f /usr/share/fzf/shell/completion.zsh ] && source /usr/share/fzf/shell/completion.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Testing to get colours in tmux
export TERM=tmux-256color
export COLORTERM=truecolor

# Load TMUX
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi
export PATH="$(brew --prefix ruby)/bin:$PATH"

