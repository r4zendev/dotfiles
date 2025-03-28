#
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com/

eval (/opt/homebrew/bin/brew shellenv)
set -x HOMEBREW_AUTOREMOVE 1 
# eval (/opt/homebrew/bin/brew shellenv fish)

# TODO: waiting for fish support
# https://github.com/pkgxdev/pkgx/issues/845
# source (pkgx --shellcode)

starship init fish | source # https://starship.rs/
zoxide init --cmd cd fish | source # 'ajeetdsouza/zoxide'
fnm --log-level quiet env --use-on-cd | source # "Schniz/fnm"
# direnv hook fish | source # https://direnv.net/
# fx --comp fish | source # https://fx.wtf/
# set -g direnv_fish_mode eval_on_arrow # trigger direnv at prompt, and on every arrow-based directory change (default)

set -U fish_greeting # disable fish greeting
# set -U fish_key_bindings fish_vi_key_bindings

set -Ux EDITOR nvim # 'neovim/neovim' text editor
# set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"


set -x PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME
fish_add_path (pnpm --global bin)

fish_add_path "$HOME/.bun/bin"

set -x XDG_CONFIG_HOME "$HOME/.config"

set -x PYENV_ROOT "$HOME/.pyenv"
if not command -v pyenv > /dev/null
  fish_add_path "$PYENV_ROOT/bin"
end
pyenv init - | source

fish_add_path $HOME/.config/bin # my custom scripts
fish_add_path $HOME/.cargo/bin # cargo
set -Ux GOPATH (go env GOPATH)
fish_add_path $GOPATH/bin # go

# fish_config theme choose Dracula
# fish_config theme choose tokyonight
fish_config theme choose catppuccin
