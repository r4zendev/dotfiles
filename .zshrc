# zsh

# source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U select-word-style
select-word-style bash

bindkey '^F' autosuggest-accept

stty -ixon  # Disable XON/XOFF flow control to free up Ctrl+Q
exit_on_ctrl_q() {
  exit
}
zle -N exit_on_ctrl_q
bindkey '^Q' exit_on_ctrl_q

# Show dotfiles
setopt globdots
# Prevent Ctrl-D from exiting window
setopt IGNORE_EOF

delete_word_backwards() {
  # local WORDCHARS='~!#$%^&*(){}[]<>?+;'
  local WORDCHARS="${WORDCHARS:s#/#}"
  zle backward-delete-word
}

zle -N delete_word_backwards
bindkey '\e^?' delete_word_backwards

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"

[ -f ~/.config/fzf/.fzf.zsh ] && source ~/.config/fzf/.fzf.zsh

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"

# Aliases
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
alias v="nvim"
alias n="nvim"
alias p="pnpm"
alias g="gitui"
alias d="lazydocker"
alias ls="lsd -a"

alias gs="git status"

alias gd="git diff"
alias gl="git log"
alias gck="git checkout"

alias ga="git add ."
alias ga_="git add"
alias gc="git commit -m"
alias gp="git push origin HEAD"
alias gap="ga && gc wip && gp"

alias gss="git stash"
alias gsv="git add . && git stash"
alias gsp="git stash pop"
alias gca="git commit --amend --no-edit"

alias ds='discordo --token "$DISCORD_TOKEN"'
alias tg="nchat"

# fnm
eval "$(fnm env --use-on-cd)"

# pure prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# alt-left / alt-right
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# init zoxide to add "z" command
eval "$(zoxide init --cmd cd zsh)"

# pnpm
export PNPM_HOME="/Users/razen/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$PATH:$(pnpm --global bin)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export JAVA_HOME="$(/usr/libexec/java_home)"
export npm_config_target_arch=x64

# AI API Keys
source ~/.zsh_env_vars
# export GEMINI_API_KEY="GEMINI_API_KEY"
# export DEEPSEEK_API_KEY="DEEPSEEK_API_KEY"
# export OPENAI_API_KEY="OPENAI_API_KEY"
# export ANTHROPIC_API_KEY="ANTHROPIC_API_KEY"

