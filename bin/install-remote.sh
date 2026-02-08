#!/bin/bash
# Minimal setup for remote Linux servers (Debian/Ubuntu)
# Usage: curl -fsSL https://raw.githubusercontent.com/r4zendev/dotfiles/main/bin/install-remote.sh | bash

set -e

echo "==> Installing packages..."
sudo apt-get update
sudo apt-get install -y git tmux ripgrep fzf

# Neovim nightly (AppImage)
echo "==> Installing Neovim nightly..."
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod +x nvim.appimage
if ./nvim.appimage --version &>/dev/null; then
  sudo mv nvim.appimage /usr/local/bin/nvim
else
  echo "==> Extracting AppImage (no FUSE)..."
  ./nvim.appimage --appimage-extract
  sudo mv squashfs-root /opt/nvim
  sudo ln -sf /opt/nvim/AppRun /usr/local/bin/nvim
  rm -f nvim.appimage
fi

# Dotfiles (nvim + tmux only)
echo "==> Setting up config..."
git clone --depth 1 https://github.com/r4zendev/dotfiles.git ~/.dotfiles 2>/dev/null || (cd ~/.dotfiles && git pull)
mkdir -p ~/.config
ln -sfn ~/.dotfiles/stow/common/.config/nvim ~/.config/nvim
ln -sfn ~/.dotfiles/stow/common/.config/tmux ~/.config/tmux

# TPM for tmux plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install nvim plugins
echo "==> Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo ""
echo "Done! Run: tmux new -s main"
