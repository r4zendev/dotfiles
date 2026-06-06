# Dotfiles

Desktop environment for my main rig and laptop.

## Tooling

| Layer          | Tooling                                                              |
| -------------- | -------------------------------------------------------------------- |
| OS / WM        | CachyOS (Arch) + Niri (Hyprland kept as fallback)                    |
| OS Shell       | DankMaterialShell (Quickshell)                                       |
| Terminal       | Ghostty + tmux + fzf                                                 |
| Terminal Shell | Fish + Starship + Zoxide                                             |
| Editor         | Neovim                                                               |
| Keyboard       | [Custom-built 34 keys alt layout](https://github.com/r4zendev/keebs) |

## Custom features

- Niri (scrollable tiling) with DankMaterialShell, Hyprland kept as a fallback session.
- Fish shell with custom helper functions (5+ useful custom fzf pickers and other system utilities).
- Tmux setup with custom pickers, persistence (restore/continuum) and utility-overlays (e.g. lazygit, lazydocker, dblab, etc.).
- Highly performant Neovim setup with 50+ plugins and a lot of custom functionality tailored to my workflow. Search-first flow, heavy `snacks.nvim` reliance, AI integration via `codecompanion.nvim` (agentic w/ MCP) & `llama.cpp` (local-first completion).

## Repository layout

| Path   | Purpose                   |
| ------ | ------------------------- |
| `stow` | Home directory configs    |
| `bin`  | Install/bootstrap scripts |

## Install

### Apply dotfiles to an existing Linux machine

```sh
git clone git@github.com:r4zendev/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles/stow
stow -t ~ common
stow -t ~ linux
```

### Full Linux bootstrap (packages + stow + services)

```sh
~/projects/dotfiles/bin/install-arch.sh
```

## macOS (secondary)

macOS support exists via `stow/darwin` and `bin/install.sh` (yabai + hammerspoon) for my laptop, but it's not actively supported anymore.
