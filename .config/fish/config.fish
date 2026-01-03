#
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com/

eval (/opt/homebrew/bin/brew shellenv fish)
set -x HOMEBREW_AUTOREMOVE 1

starship init fish | source # https://starship.rs/
zoxide init --cmd cd fish | source # 'ajeetdsouza/zoxide'
fnm --log-level quiet env --use-on-cd | source # "Schniz/fnm"
fx --comp fish | source # https://fx.wtf/

set -U fish_greeting # disable fish greeting
# i don't use vi mode in fish
# set -U fish_key_bindings fish_vi_key_bindings

set -Ux EDITOR nvim # 'neovim/neovim' text editor
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
fzf --fish | source

set -x PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME
fish_add_path (pnpm --global bin)

fish_add_path "$HOME/.bun/bin"

set -x XDG_CONFIG_HOME "$HOME/.config"

fish_add_path $HOME/.local/bin # local bin
fish_add_path $HOME/.config/bin # my custom scripts
fish_add_path $HOME/.cargo/bin # cargo
set -Ux GOPATH (go env GOPATH)
fish_add_path $GOPATH/bin # go

fish_add_path (uv python dir)/cpython-3.13.2-macos-aarch64-none/bin # python
fish_add_path ~/.global-python/bin # python global installs using uv

# view man pages using Neovim
set -Ux MANPAGER "nvim +Man!"

# fish_config theme choose Dracula
# fish_config theme choose tokyonight
fish_config theme choose catppuccin

