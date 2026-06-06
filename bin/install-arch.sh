#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────
# Raw Arch bootstrap for razen's machine.
#
# Assumes: a base Arch install is already done (pacstrap + kernel + bootloader
# + a regular user with sudo, booted into the new system). This script then
# brings the system up to the full desktop. It is safe to re-run (`--needed`).
#
# Targets vanilla Arch (not CachyOS): enables multilib, refreshes mirrors,
# bootstraps paru, installs the NVIDIA kernel module, and uses greetd + the
# DankMaterialShell greeter instead of SDDM.
# ─────────────────────────────────────────────────────────────────────

# ── Pacman config: multilib (needed for lib32-*), color, parallel dl ──
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
  sudo sed -i '/^#\[multilib\]$/,+1 s/^#//' /etc/pacman.conf
fi
sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf
grep -q '^ParallelDownloads' /etc/pacman.conf || sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf

# ── Mirrors ───────────────────────────────────────────────────────────
sudo pacman -Sy --needed --noconfirm reflector
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syu --noconfirm

# ── paru (AUR helper) ─────────────────────────────────────────────────
if ! command -v paru &>/dev/null; then
  echo "Installing paru (AUR helper)"
  sudo pacman -S --needed --noconfirm git base-devel
  tmp="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru.git "$tmp/paru"
  (cd "$tmp/paru" && makepkg -si --noconfirm)
else
  printf 'paru already installed, skipping.\n'
fi

# ── Dotfiles ──────────────────────────────────────────────────────────
mkdir -p "$HOME/projects"
DOTFILES_DIR="$HOME/projects/dotfiles"
[ -d "$DOTFILES_DIR" ] || git clone https://github.com/r4zendev/dotfiles.git "$DOTFILES_DIR"

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

# ── Wayland (shared: Hyprland + Niri + Sway) ──────────────────────────
paru -S --needed \
  hyprland \
  hyprlock \
  hyprpaper \
  hyprpicker \
  hyprpolkitagent \
  hyprsunset \
  hyprwhspr \
  hyprshutdown \
  uwsm \
  awww \
  wayscriber \
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

# ── Niri + DankMaterialShell ──────────────────────────────────────────
# dms-shell + per-compositor integrations live in Arch `extra`.
# matugen powers DMS dynamic theming; cava is the audio visualizer.
paru -S --needed \
  niri \
  xwayland-satellite \
  quickshell \
  dms-shell \
  dms-shell-niri \
  dms-shell-hyprland \
  xdg-desktop-portal-wlr \
  matugen \
  cava

# ── Sway (headless game-streaming session) ────────────────────────────
paru -S --needed \
  sway \
  swaybg \
  sunshine

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
  awesome-terminal-fonts \
  papirus-icon-theme

# ── Media codecs / thumbnails ────────────────────────────────────────
paru -S --needed \
  gst-plugins-good \
  gst-plugins-bad \
  gst-plugins-ugly \
  gst-libav \
  ffmpegthumbnailer \
  libdvdcss

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

# ── KDE / Qt integration + GTK themes ────────────────────────────────
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
  ydotool \
  speech-dispatcher \
  cpupower \
  power-profiles-daemon \
  upower \
  smartmontools \
  ufw

# ── pacman tooling ────────────────────────────────────────────────────
paru -S --needed \
  reflector \
  pacman-contrib \
  pkgfile

# ── NVIDIA (RTX 4070 Ti SUPER) ───────────────────────────────────────
# nvidia-open-dkms = the kernel module (open variant, Turing+). linux-headers
# is required to build it. Assumes the `linux` kernel; adjust if using another.
paru -S --needed \
  linux-headers \
  nvidia-open-dkms \
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
# NOTE: on raw Arch the bootloader is installed/configured manually during
# base setup; these packages provide the snapshot-boot tooling only.
paru -S --needed \
  limine \
  limine-mkinitcpio-hook \
  limine-snapper-sync \
  efibootmgr \
  efitools \
  sbctl

# ── Display manager (greetd + DankMaterialShell greeter) ─────────────
paru -S --needed \
  greetd \
  greetd-dms-greeter-git

# ── Printing ──────────────────────────────────────────────────────────
paru -S --needed \
  cups \
  cups-filters \
  cups-pk-helper \
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

# ── OPTIONAL (uncomment what you want on a given machine) ─────────────
# paru -S --needed \
#   firefox \
#   chromium chromium-ffmpeg \
#   multimc-bin \
#   vencord \
#   ventoy-bin \
#   woeusb-ng \
#   waifu2x-ncnn-vulkan \
#   youtube-tui \
#   glances \
#   bluetui \
#   freerdp \
#   sshfs \
#   ghc opam

# ── Enable system services ────────────────────────────────────────────
sudo systemctl enable bluetooth
sudo systemctl enable cups
sudo systemctl enable avahi-daemon
sudo systemctl enable NetworkManager
sudo systemctl enable iwd
sudo systemctl enable keyd
sudo systemctl enable input-remapper
sudo systemctl enable mullvad-daemon
sudo systemctl enable ufw
sudo systemctl enable fstrim.timer
sudo systemctl enable snapper-cleanup.timer
sudo systemctl enable cpupower
sudo systemctl enable limine-snapper-sync

# ── Stow dotfiles ─────────────────────────────────────────────────────
# Pre-create runtime dirs so stow links individual files instead of folding
# the whole dir into a symlink (DMS/GTK write generated files into these).
mkdir -p "$HOME/.config/DankMaterialShell" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cd "$DOTFILES_DIR/stow"
stow -t "$HOME" common
stow -t "$HOME" linux

# ── Display manager: greetd with the DankMaterialShell greeter ────────
# Configures /etc/greetd to launch the DMS greeter; replaces SDDM.
dms greeter install
dms greeter enable
sudo systemctl enable greetd

# ── DMS plugins + GTK dynamic-color import (theme settings come from stow) ──
dms plugins install dankKDEConnect || true
for d in gtk-3.0 gtk-4.0; do
  grep -qs dank-colors "$HOME/.config/$d/gtk.css" 2>/dev/null ||
    echo '@import url("dank-colors.css");' >"$HOME/.config/$d/gtk.css"
done

# ── Enable user services (after stow links the custom unit files) ─────
systemctl --user enable pipewire.socket
systemctl --user enable pipewire-pulse.socket
systemctl --user enable wireplumber
systemctl --user enable hyprpolkitagent
systemctl --user enable hyprsunset
systemctl --user enable hyprwhspr
systemctl --user enable ydotool.service

# Headless game streaming (Sway + Sunshine). Comment out on non-streaming rigs.
systemctl --user enable sway-sunshine.service
systemctl --user enable sunshine-headless.service
systemctl --user enable sunshine-audio.service

# ── KDE service menus ────────────────────────────────────────────────
if [ -f "$DOTFILES_DIR/system-files/kio-servicemenus/admin-folder.desktop" ]; then
  sudo cp "$DOTFILES_DIR/system-files/kio-servicemenus/admin-folder.desktop" /usr/share/kio/servicemenus/
  sudo chmod 644 /usr/share/kio/servicemenus/admin-folder.desktop
fi

echo "Done. Reboot to apply all changes (greetd will start the DMS greeter)."
