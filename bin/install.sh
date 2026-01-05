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
brew install --cask wezterm     # terminal emulator
brew install starship           # prompt customization
brew install tmux               # terminal multiplexer
brew install sesh               # tmux session manager
brew install bash               # running bash scripts
brew install fish               # daily driver
brew install fisher             # package manager for fish
brew install --cask claude-code # AI assistant [1]
brew install --cask codex       # AI assistant [2]
brew install opencode           # AI assistant [3]
# brew install neovim --HEAD

# Zsh
# brew install zsh
# brew install zsh-autocomplete
# brew install zsh-autosuggestions
# brew install zsh-syntax-highlighting

# Git
brew install gh
brew install git
# brew install git-delta
# brew install difftastic
brew install lazygit # git UI

# Docker
brew install docker # docker CLI
brew install docker-compose
brew install docker-credential-helper
brew install colima     # docker driver
brew install lazydocker # docker UI

# Node
brew install oven-sh/bun/bun # runtime
brew install pnpm            # package manager
brew install fnm             # node manager

# brew install zig # stable
brew install zigup # master
zigup master
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
brew install uv

brew install curlie # curl alternative
brew install xh     # daily driver

# File management / navigation
brew install yazi   # file manager
brew install zoxide # cd alternative

# Window management
# brew install --cask nikitabobko/tap/aerospace
# OR
brew install yabai
# AND THEN
# sudo yabai --install-sa
# yabai --load-sa
# yabai --start-service

# Various utils (monitoring, peeking, searching, exploring, etc.)
brew install bat      # cat alternative
brew install btop     # system monitor
brew install duti     # default app handler -> `duti -s net.imput.helium .md all`
brew install fd       # find alternative
brew install fx       # JSON viewer
brew install ffmpeg   # multimedia processing
brew install fzf      # fuzzy finder
brew install gdu      # disk usage analyzer
brew install jq       # JSON processor
brew install lsd      # ls alternative
brew install neofetch # system info
brew install pgcli    # postgres client
brew install ripgrep  # search engine
brew install tealdeer # quick man-pages extracts
brew install yt-dlp   # youtube downloader
pnpm i -g fkill-cli   # kill processes

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-monaspace
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-inconsolata-lgc-nerd-font # cyrillic
# brew install --cask font-maple-mono

# Apps
brew install th-ch/youtube-music/youtube-music
brew install --cask 1password
brew install --cask discord
brew install --cask obsidian
brew install --cask slack
brew install --cask telegram
brew install --cask helium-browser

# System utils
brew install --cask blender      # 3D modeling
brew install --cask hammerspoon  # advanced scripting & automation
brew install jordanbaird-ice     # toolbar
brew install --cask keycastr     # keylogger
brew install --cask linearmouse  # app to reverse external mouse scroll
brew install imagemagick         # image processing
brew install --cask superwhisper # Voice to text
