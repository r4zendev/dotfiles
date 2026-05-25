#!/bin/bash
set -euo pipefail

# Install paru (AUR helper) if not present
if [[ -z $(command -v paru) ]]; then
  echo "Installing paru (AUR helper)"
  sudo pacman -Syu --needed git base-devel
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  cd /tmp/paru && makepkg -si
  cd ~
else
  printf 'paru is already installed, skip it.\n'
fi

paru -Syu

cd ~ && mkdir -p projects && cd projects
git clone git@github.com:r4zendev/dotfiles.git dotfiles || true

# ── Terminal environment ──────────────────────────────────────────────
paru -S --needed \
  ghostty \
  starship \
  tmux \
  sesh-bin \
  bash \
  fish \
  neovim \
  dblab-bin \
  opencode-bin \
  micro

curl -fsSL https://claude.ai/install.sh | bash

# ── Git ───────────────────────────────────────────────────────────────
paru -S --needed \
  git \
  git-delta \
  github-cli \
  jujutsu \
  lazygit

# ── Docker ────────────────────────────────────────────────────────────
paru -S --needed \
  docker \
  docker-compose \
  lazydocker
sudo systemctl enable docker
sudo usermod -aG docker "$USER"

# ── Package managers / Runtimes ───────────────────────────────────────
paru -S --needed \
  bun-bin \
  pnpm \
  uv \
  mise

# ── HTTP clients ──────────────────────────────────────────────────────
paru -S --needed \
  curlie \
  xh

# ── Wayland / Hyprland ───────────────────────────────────────────────
paru -S --needed \
  hyprland \
  hyprlock \
  hyprpaper \
  hyprpicker \
  hyprpolkitagent \
  hyprsunset \
  hyprwhspr \
  uwsm \
  wl-clipboard \
  wl-clip-persist \
  cliphist \
  clipse \
  grim \
  slurp \
  wf-recorder \
  wev \
  wtype \
  fuzzel \
  waybar \
  xdg-desktop-portal-hyprland \
  xdg-desktop-portal-gtk \
  bibata-cursor-git

# ── Novashell (AGS/Astal bar) ────────────────────────────────────────
paru -S --needed \
  aylurs-gtk-shell-git \
  libastal-meta \
  gtk4 \
  libadwaita \
  dart-sass \
  python-pywal16 \
  libcanberra

# ── Audio ─────────────────────────────────────────────────────────────
paru -S --needed \
  pipewire \
  pipewire-alsa \
  pipewire-jack \
  pipewire-pulse \
  wireplumber \
  pavucontrol \
  playerctl \
  rtkit

# ── Bluetooth ────────────────────────────────────────────────────────
paru -S --needed \
  bluez \
  bluez-utils \
  blueman \
  overskride

# ── Networking ────────────────────────────────────────────────────────
paru -S --needed \
  networkmanager \
  networkmanager-openvpn \
  iwd \
  mullvad-vpn \
  openssh \
  bind \
  ethtool \
  impala

# ── CLI utils ─────────────────────────────────────────────────────────
paru -S --needed \
  bat \
  btop \
  cowsay \
  duf \
  fd \
  ffmpeg \
  figlet \
  fx \
  fzf \
  gdu \
  jq \
  less \
  lsd \
  fastfetch \
  pv \
  ripgrep \
  rsync \
  stow \
  tree \
  wget \
  yazi \
  yt-dlp \
  zoxide \
  sqlit \
  plocate

# ── Fonts ─────────────────────────────────────────────────────────────
paru -S --needed \
  ttf-jetbrains-mono-nerd \
  ttf-meslo-nerd \
  ttf-iosevka-nerd \
  otf-monaspace \
  ttf-dejavu \
  ttf-liberation \
  ttf-opensans \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  noto-color-emoji-fontconfig \
  cantarell-fonts \
  papirus-icon-theme

# ── Desktop apps ──────────────────────────────────────────────────────
paru -S --needed \
  1password \
  blender \
  discord \
  gimp \
  libreoffice-fresh \
  obs-studio \
  qbittorrent \
  slack-desktop \
  telegram-desktop \
  vesktop-bin \
  vlc \
  zen-browser-bin \
  helium-browser-bin \
  pear-desktop \
  losslesscut-bin

# ── File management ──────────────────────────────────────────────────
paru -S --needed \
  dolphin \
  kio-admin \
  ark \
  loupe \
  qimgv \
  imv \
  nomacs

# ── KDE integration ──────────────────────────────────────────────────
paru -S --needed \
  kdeconnect \
  kactivitymanagerd \
  plasma-activities-stats \
  kde-cli-tools \
  qt5ct \
  qt6ct \
  qt6-virtualkeyboard \
  adw-gtk-theme \
  catppuccin-gtk-theme-mocha \
  gnome-themes-extra

# ── System / Hardware ────────────────────────────────────────────────
paru -S --needed \
  keyd \
  input-remapper \
  solaar \
  openrazer-daemon \
  openrazer-driver-dkms \
  polychromatic \
  razer-cli \
  cpupower \
  power-profiles-daemon \
  upower \
  ufw \
  cups

# ── NVIDIA ────────────────────────────────────────────────────────────
paru -S --needed \
  nvidia-utils \
  nvidia-settings \
  lib32-nvidia-utils \
  opencl-nvidia \
  lib32-opencl-nvidia \
  libva-nvidia-driver \
  cuda \
  egl-wayland \
  vulkan-tools \
  vulkan-validation-layers \
  vulkan-headers

# ── AMD (iGPU) ────────────────────────────────────────────────────────
paru -S --needed \
  vulkan-radeon \
  lib32-vulkan-radeon \
  lib32-mesa \
  xf86-video-amdgpu \
  mesa-utils

# ── BTRFS / Snapper ──────────────────────────────────────────────────
paru -S --needed \
  btrfs-progs \
  btrfs-assistant \
  snapper \
  inotify-tools

# ── Bootloader (Limine) ──────────────────────────────────────────────
paru -S --needed \
  limine \
  limine-mkinitcpio-hook \
  limine-snapper-sync \
  efibootmgr \
  efitools \
  sbctl

# ── Display manager ──────────────────────────────────────────────────
paru -S --needed \
  sddm

# ── Printing ──────────────────────────────────────────────────────────
paru -S --needed \
  cups \
  cups-filters \
  brother-hl-l1230w

# ── Dev tools ─────────────────────────────────────────────────────────
paru -S --needed \
  cmake \
  ninja \
  python \
  android-tools \
  imagemagick \
  renderdoc \
  helix

# ── 3D printing / CAD ────────────────────────────────────────────────
paru -S --needed \
  freecad \
  openscad \
  kicad \
  kicad-library \
  bambustudio-bin \
  orca-slicer-git

# ── Embedded ─────────────────────────────────────────────────────────
paru -S --needed \
  arm-none-eabi-gcc \
  arm-none-eabi-newlib \
  picocom

# ── AI / LLM ─────────────────────────────────────────────────────────
paru -S --needed \
  llama.cpp-cuda-git \
  gemini-cli

# ── Crypto ────────────────────────────────────────────────────────────
paru -S --needed \
  trezor-suite-appimage

# ── Music production ─────────────────────────────────────────────────
paru -S --needed \
  supercollider \
  sc3-plugins \
  haskell-tidal

# ── Misc ──────────────────────────────────────────────────────────────
paru -S --needed \
  gum \
  handbrake \
  meld \
  dialect \
  mission-center

# ── Enable services ──────────────────────────────────────────────────
sudo systemctl enable bluetooth
sudo systemctl enable cups
sudo systemctl enable NetworkManager
sudo systemctl enable iwd
sudo systemctl enable sddm
sudo systemctl enable keyd
sudo systemctl enable input-remapper
sudo systemctl enable mullvad-daemon
sudo systemctl enable ufw
sudo systemctl enable fstrim.timer
sudo systemctl enable snapper-cleanup.timer
sudo systemctl enable cpupower
sudo systemctl enable limine-snapper-sync

# ── User services ────────────────────────────────────────────────────
systemctl --user enable pipewire.socket
systemctl --user enable pipewire-pulse.socket
systemctl --user enable wireplumber
systemctl --user enable hyprpolkitagent
systemctl --user enable hyprsunset
systemctl --user enable hyprwhspr

# ── Stow dotfiles ────────────────────────────────────────────────────
DOTFILES_DIR="$HOME/projects/dotfiles"
cd "$DOTFILES_DIR/stow"
stow -t "$HOME" common
stow -t "$HOME" linux

# ── KDE service menus ────────────────────────────────────────────────
if [ -f "$DOTFILES_DIR/system-files/kio-servicemenus/admin-folder.desktop" ]; then
  sudo cp "$DOTFILES_DIR/system-files/kio-servicemenus/admin-folder.desktop" /usr/share/kio/servicemenus/
  sudo chmod 644 /usr/share/kio/servicemenus/admin-folder.desktop
fi

# ── Build novashell ──────────────────────────────────────────────────
cd "$DOTFILES_DIR/novashell"
pnpm install
pnpm build
mkdir -p ~/.local/bin
ln -sf "$DOTFILES_DIR/novashell/build/novashell" ~/.local/bin/novashell
ln -sf "$DOTFILES_DIR/novashell/build/nsh" ~/.local/bin/nsh

echo "Done. Reboot to apply all changes."
