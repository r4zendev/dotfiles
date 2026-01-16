#!/bin/bash

# Install yay (AUR helper) if not present
if [[ -z $(command -v yay) ]]; then
  echo "Installing yay (AUR helper)"
  sudo pacman -Syu --needed git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si
  cd ~
else
  printf 'yay is already installed, skip it.\n'
fi

# Update system first to avoid partial upgrades
yay -Syu

cd ~ && mkdir -p projects/r4zendotdev && cd projects/r4zendotdev
git clone git@github.com:r4zendev/dotfiles.git dotfiles

# Terminal environment
yay -S --needed ghostty
# yay -S --needed wezterm
sudo pacman -S --needed starship
sudo pacman -S --needed tmux
yay -S --needed sesh-bin
sudo pacman -S --needed bash
sudo pacman -S --needed fish
yay -S --needed fisher
yay -S --needed claude-code-cli
curl -fsSL https://opencode.ai/install | bash
yay -S --needed dblab-bin
sudo pacman -S --needed neovim

# Git
sudo pacman -S --needed github-cli
sudo pacman -S --needed git
yay -S --needed jujutsu
# sudo pacman -S --needed git-delta
# sudo pacman -S --needed difftastic
sudo pacman -S --needed lazygit

# Docker
sudo pacman -S --needed docker
sudo pacman -S --needed docker-compose
yay -S --needed docker-credential-helper
sudo pacman -S --needed lazydocker
# Enable docker service
# sudo systemctl enable --now docker
# sudo usermod -aG docker $USER

# PMs / Runtimes
yay -S --needed bun-bin
sudo pacman -S --needed pnpm

yay -S --needed uv

# Curl alternatives
yay -S --needed curlie
sudo pacman -S --needed xh

# Window management (Arch alternatives to yabai)
sudo pacman -S --needed hyprland
sudo pacman -S --needed waybar       # status bar
sudo pacman -S --needed wofi         # app launcher
sudo pacman -S --needed wl-clipboard # clipboard (wl-copy/wl-paste)
sudo pacman -S --needed grim         # screenshot tool
sudo pacman -S --needed slurp        # region selection for screenshots
sudo pacman -S --needed mako         # notification daemon
yay -S --needed hyprpaper            # wallpapers
yay -S --needed bibata-cursor-git    # cursor theme

yay -S --needed cliphist        # clipboard manager
yay -S --needed wl-clip-persist # keeps clipboard after app closes

sudo pacman -S --needed xdg-desktop-portal-hyprland # screen sharing support
yay -S --needed wf-recorder                         # screen recording for Wayland
# sudo pacman -S --needed polkit-kde-agent

# yay -S --needed hyprlock # lock screen
# yay -S --needed hypridle # auto-lock/suspend on idle

# Various utils (monitoring, peeking, searching, exploring, etc.)
sudo pacman -S --needed bat       # cat alternative
sudo pacman -S --needed btop      # system monitor
sudo pacman -S --needed fd        # find alternative
sudo pacman -S --needed ffmpeg    # multimedia processing
sudo pacman -S --needed figlet    # text banners
yay -S --needed fx                # JSON viewer
sudo pacman -S --needed fzf       # fuzzy finder
sudo pacman -S --needed gdu       # disk usage analyzer
sudo pacman -S --needed jq        # JSON processor
sudo pacman -S --needed lsd       # ls alternative
yay -S --needed mise              # version manager
sudo pacman -S --needed fastfetch # system info (neofetch replacement)
sudo pacman -S --needed pgcli     # postgres client
sudo pacman -S --needed ripgrep   # search engine
sudo pacman -S --needed tealdeer  # quick man-pages extracts
sudo pacman -S --needed yazi      # file manager
sudo pacman -S --needed yt-dlp    # youtube downloader
sudo pacman -S --needed zoxide    # cd alternative
pnpm i -g fkill-cli               # kill processes

# Fonts
sudo pacman -S --needed ttf-jetbrains-mono-nerd
yay -S --needed ttf-monaspace
yay -S --needed ttf-inconsolata-lgc-nerd # cyrillic

# Apps
yay -S --needed 1password
sudo pacman -S --needed blender
sudo pacman -S --needed discord
# helium-browser - https://github.com/imputnet/helium-linux
yay -S --needed zen-browser-bin
yay -S --needed obsidian
yay -S --needed slack-desktop
sudo pacman -S --needed telegram-desktop
yay -S --needed youtube-music-bin

# System utils
sudo pacman -S --needed imagemagick
yay -S --needed pngpaste
yay -S --needed keyd        # keyboard remapping
yay -S --needed whisper.cpp # local whisper ASR

# BTRFS snapshots (requires BTRFS filesystem)
sudo pacman -S --needed snapper       # snapshot management
sudo pacman -S --needed snap-pac      # auto snapshots on pacman transactions
yay -S --needed grub-btrfs            # boot into snapshots from GRUB
sudo pacman -S --needed inotify-tools # required for grub-btrfsd

# Game dev
sudo pacman -S --needed pipewire wireplumber pipewire-pulse pavucontrol # audio server and control
sudo pacman -S --needed playerctl                                       # media key control
sudo pacman -S --needed vulkan-tools vulkan-validation-layers
sudo pacman -S --needed renderdoc # graphics debugger

# Snapper setup (run manually after install):
# 1. Create snapper config for root:
#    sudo snapper -c root create-config /
#
# 2. Set snapshot limits in /etc/snapper/configs/root:
#    TIMELINE_LIMIT_HOURLY="5"
#    TIMELINE_LIMIT_DAILY="7"
#    TIMELINE_LIMIT_WEEKLY="0"
#    TIMELINE_LIMIT_MONTHLY="0"
#    TIMELINE_LIMIT_YEARLY="0"
#
# 3. Enable services:
#    sudo systemctl enable --now snapper-timeline.timer
#    sudo systemctl enable --now snapper-cleanup.timer
#    sudo systemctl enable --now grub-btrfsd
#
# 4. Regenerate GRUB config:
#    sudo grub-mkconfig -o /boot/grub/grub.cfg
