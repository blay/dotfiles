case "$OSTYPE" in
  darwin*)

# FZF keybindings and completion (Homebrew install)
[ -f "$(brew --prefix fzf)/shell/key-bindings.zsh" ] && source "$(brew --prefix fzf)/shell/key-bindings.zsh"
[ -f "$(brew --prefix fzf)/shell/completion.zsh" ] && source "$(brew --prefix fzf)/shell/completion.zsh"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

  ;;
  linux*)


  ;;
esac
