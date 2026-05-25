#!/usr/bin/env bash
set -euo pipefail

echo "==> Post-install: tools not in nixpkgs"

# Claude Code CLI
if ! command -v claude &>/dev/null; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
fi

# OpenCode
if ! command -v opencode &>/dev/null; then
  echo "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
fi

# Stow dotfiles
echo "==> Stowing dotfiles..."
DOTFILES_DIR="$HOME/projects/dotfiles"
if [ -d "$DOTFILES_DIR/stow" ]; then
  cd "$DOTFILES_DIR/stow"
  stow -t "$HOME" common
  stow -t "$HOME" linux
  echo "Dotfiles stowed."
else
  echo "Dotfiles not found at $DOTFILES_DIR — clone them first."
fi

# TPM (tmux plugin manager)
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Fisher (fish plugin manager)
if command -v fish &>/dev/null && ! fish -c 'type -q fisher' 2>/dev/null; then
  echo "Installing Fisher..."
  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
fi

echo "==> Done. Reboot or log out/in to apply all changes."
