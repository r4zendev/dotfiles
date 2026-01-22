#!/bin/bash

if [[ -z $(command -v brew) ]]; then
  echo "Install Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  printf 'Homebrew is already installed, skip it.\n'
fi

cd ~ && mkdir -p projects/r4zendotdev && cd projects/r4zendotdev
git clone git@github.com:r4zendev/dotfiles.git dotfiles

# Terminal environment
brew install --cask ghostty
# brew install --cask wezterm
brew install starship
brew install tmux
brew install sesh
brew install bash
brew install fish
brew install fisher
brew install --cask codex
curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://opencode.ai/install | bash
brew install --cask danvergara/tools/dblab
brew install neovim --HEAD

# Git
brew install gh
brew install git
brew install jj
# brew install git-delta
# brew install difftastic
brew install lazygit

# Docker
brew install docker # docker CLI
brew install docker-compose
brew install docker-credential-helper
brew install colima
brew install lazydocker

# PMs / Runtimes
brew install oven-sh/bun/bun
brew install pnpm

brew install uv

# Curl
brew install curlie
brew install xh

# Window management
brew install yabai
# sudo yabai --install-sa
# yabai --load-sa
# yabai --start-service

# Various utils (monitoring, peeking, searching, exploring, etc.)
brew install bat      # cat alternative
brew install btop     # system monitor
brew install duti     # default app handler -> `duti -s net.imput.helium .md all`
brew install fd       # find alternative
brew install ffmpeg   # multimedia processing
brew install figlet   # text banners
brew install fx       # JSON viewer
brew install fzf      # fuzzy finder
brew install gdu      # disk usage analyzer
brew install jq       # JSON processor
brew install lsd      # ls alternative
brew install mise     # version manager
brew install neofetch # system info
brew install pgcli    # postgres client
brew install ripgrep  # search engine
brew install tealdeer # quick man-pages extracts
brew install yazi     # file manager
brew install yt-dlp   # youtube downloader
brew install zoxide   # cd alternative
pnpm i -g fkill-cli   # kill processes

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-monaspace
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-inconsolata-lgc-nerd-font # cyrillic
# brew install --cask font-maple-mono

# Apps
brew install --cask 1password
brew install --cask blender
brew install --cask discord
brew install --cask gimp
brew install --cask helium-browser
brew install --cask libreoffice
brew install --cask obsidian
brew install --cask slack
brew install --cask superwhisper
brew install --cask telegram
brew install th-ch/youtube-music/youtube-music

# System utils
brew install --cask hammerspoon
brew install jordanbaird-ice
brew install --cask keycastr
brew install --cask linearmouse
brew install imagemagick
brew install pngpaste
brew install android-platform-tools
