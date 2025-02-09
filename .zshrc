# zsh

source ~/zsh-plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"

[ -f ~/.config/fzf/.fzf.zsh ] && source ~/.config/fzf/.fzf.zsh

export EDITOR="nvim"

# Aliases
alias lg="lazygit"
alias ls="lsd -a"
alias p="pnpm"
alias g="gitui"
alias v="nvim"
alias n="nvim"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# alias python=python3
# alias pip=pip3

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
export GEMINI_API_KEY="GEMINI_API_KEY"
export DEEPSEEK_API_KEY="DEEPSEEK_API_KEY"
# export OPENAI_API_KEY="OPENAI_API_KEY"
# export ANTHROPIC_API_KEY="ANTHROPIC_API_KEY"

