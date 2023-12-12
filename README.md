# Dotfiles

These are files that add custom configurations to my computer and applications, primarily the terminal.

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/r4zendev/dotfiles/main/install.sh | bash
```

## Software

- Terminal: [Alacritty](https://alacritty.org/)
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
- Shell: [fish](https://fishshell.com/)
- Prompt: [starship](https://starship.rs/)
- Editor: [Neovim](https://neovim.io)
  <!-- - Git: [gitui](https://github.com/extrawurst/gitui) -->
  <!-- - Docker: [lazydocker](https://github.com/jesseduffield/lazydocker) -->
- Font: [Fira Code](https://github.com/tonsky/FiraCode)
- Colors: [custom Neovim theme](.config/nvim/lua) and [tokyonight](https://github.com/folke/tokyonight.nvim) for the rest
- Hotkeys: [Karabiner](https://karabiner-elements.pqrs.org/)
- Window manager: [yabai](https://github.com/koekeishiya/yabai)
- macOS package manager: [Homebrew](https://brew.sh)
- npm package manager: [pnpm](https://pnpm.io/)
- Some of the cmd utils used: 🦇bat, ⚙️brew, 📈btop, 🔍fd, 🛑fkill, ☕️fnm, 🕵️‍♂️fzf, 💾gdu, 🐱gh, 🐧git, 📝jq, 🔍ripgrep, 🚀zoxide

## Future

- [ ] Add missing essential plugins:
  - [ ] copilot
  - [ ] vim-visual-multi
  - [ ] project
  - [ ] glance
  - [ ] nvim-spectre
- [ ] Tweak neovim configuration that I have shamelessly stolen and learn the shortcuts
- [ ] Improve which-key to learn scs faster
- [ ] Add more Neovim & shell keymaps
- [ ] Finish initial dotfiles setup and installation script
- [ ] Dogfood current setup
- [ ] Improve the usage of the following tools in regular day-to-day workflow:
  - [ ] zoxide
  - [ ] tmux
  - [ ] harpoon
- [ ] Cleanup fish config
- [ ] Add more Neovim plugins of taste:
  - [ ] flash
  - [ ] oil
  - [ ] aerial
  - [ ] toggleterm with gitui
  - [ ] vim-move
- [ ] Setup default prettier config path
- [ ] Rust Neovim setup
- [ ] Adapt 1password & Fantastical
- [ ] Adapt [gitui](https://github.com/extrawurst/gitui), [lazydocker](https://github.com/jesseduffield/lazydocker), [yazi](https://github.com/DreamMaoMao/yazi.nvim), [espanso](https://espanso.org/)
- [ ] Configure & adapt [Wezterm](https://wezfurlong.org/wezterm/) from scratch (current config file is a good set of defaults)
- [ ] Ditch tmux for Wezterm panes if they're fine
- [ ] Learn more goddamn Lua
- [ ] Improve Neovim setup with Lua knowledge gained, [Primeagen VIM as your editor](https://www.youtube.com/playlist?list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R) playlist and references, such as [LazyVim](https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim), [ayamir](https://github.com/ayamir/nvimdots)

Long way ahead we've got... Hope it's going to be fun!

## Hardware

- Laptop: 13-inch MacBook Air, Apple M2 Chip, 16GB RAM, Late 2022
- Keyboard: [MoErgo Glove80](https://www.moergo.com/collections/glove80-keyboards/products/glove80-split-ergonomic-keyboard-revision-2) with [my own layout](https://github.com/r4zendev/glove80-zmk-config) using **Colemak-DH**
- Mouse: [Kensington Slimblade Pro](https://www.kensington.com/p/products/electronic-control-solutions/trackball-products/slimblade-pro-trackball/)

## 🎉 Acknowledgment

Thanks to these wonderful people and repos, I was able to assemble this dotfiles repository of mine.

- [joshmedeski/dotfiles](https://github.com/joshmedeski/dotfiles)
- [Josean Martinez](https://github.com/josean-dev/dev-environment-files/)
- and more...
