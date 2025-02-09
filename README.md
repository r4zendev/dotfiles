# Dotfiles

This is the home of all my dotfiles. These are files that add custom configurations to my computer and applications, primarily the terminal.

## Installation

My dotfiles are managed by [GNU Stow](https://www.gnu.org/software/stow/).

1. Install [homebrew](https://brew.sh/)
2. Install [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)
3. Clone this repository
4. Run stow command

```sh
stow . -t ~
```

## Software

- Terminal: [Alacritty](https://alacritty.org/)
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
- Shell: [zsh](https://www.zsh.org/)
- Prompt: [pure](https://github.com/sindresorhus/pure)
- Editor: [Neovim](https://neovim.io)
- Git: [gitui](https://github.com/extrawurst/gitui)
- Docker: [lazydocker](https://github.com/jesseduffield/lazydocker)
- Font: [Fira Code](https://github.com/tonsky/FiraCode)
- Colors: [tokyonight](https://github.com/folke/tokyonight.nvim) mostly
- Hotkeys: [Karabiner](https://karabiner-elements.pqrs.org/)
- Window manager: [yabai](https://github.com/koekeishiya/yabai)
- macOS package manager: [Homebrew](https://brew.sh)
- npm package manager: [pnpm](https://pnpm.io/)
- Other tools: brew, fd, ripgrep, zoxide, fzf, yazi, gdu ...

## Hardware

- Laptop: 13-inch MacBook Air, Apple M2 Chip, 16GB RAM, Late 2022
- During free time, I practice my [MoErgo Glove80](https://www.moergo.com/collections/glove80-keyboards/products/glove80-split-ergonomic-keyboard-revision-2) with [my own layout](https://github.com/r4zendev/glophite) based on Graphite keyboard layout

## Future

- [ ] Add more shortcuts and integrate with which-key
- [ ] Review Alacritty keymaps
- [ ] Setup default prettier config path
- [ ] Rust/C++ Neovim setup

## 🎉 Acknowledgment

Thanks to these wonderful people and repos, I was able to assemble this dotfiles repository of mine.

- [joshmedeski/dotfiles](https://github.com/joshmedeski/dotfiles)
- [Josean Martinez](https://github.com/josean-dev/dev-environment-files/)
