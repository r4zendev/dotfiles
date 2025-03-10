#/bin/bash

if [[ -z $(command -v brew) ]]; then
	echo "Install Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	printf 'Homebrew is already installed, skip it.\n'
fi

cd ~ && mkdir -p projects/r4zendotdev && cd projects/r4zendotdev
git clone git@github.com:razenization/dotfiles.git dotfiles

# Terminal environment
brew install --cask wezterm # terminal emulator
brew install starship # prompt customization
brew install tmux # terminal multiplexer
brew install bash # running bash scripts
brew install fish # daily driver
brew install fisher # package manager for fish
brew install aider # AI assistant
# brew install zsh
brew install neovim # editor

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
brew install colima # docker driver
brew install lazydocker # docker UI

# Node ecosystem
brew install oven-sh/bun/bun # runtime
brew install pnpm # package manager
brew install fnm # node manager

brew install curlie # curl alternative
brew install xh # daily driver
brew install hurl # testing & advanced

# File management / navigation
brew install yazi # file manager
brew install zoxide # cd alternative

# System utils
brew install thefuck # correction tool
brew install --cask hammerspoon # advanced scripting & automation
brew install jordanbaird-ice # toolbar for macOS

# Zsh add-ons
brew install zsh-autocomplete
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

# Window management
brew install yabai
yabai --start-service

# Various utils (monitoring, peeking, searching, exploring, etc.)
brew install bat # cat alternative
brew install btop # system monitor
brew install gdu # disk usage analyzer
brew install jq # JSON processor
brew install fd # find alternative
brew install fzf # fuzzy finder
brew install tealdeer # quick man-pages extracts
brew install ripgrep # search engine
brew install pgcli # postgres client
brew install neofetch # system info
brew install lsd # ls alternative
brew install yt-dlp # youtube downloader
pnpm i -g fkill-cli # kill processes

# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-monaspace
brew install --cask font-jetbrains-mono-nerd-font

# Apps
brew install --cask 1password
brew install --cask discord          
brew install --cask obsidian         
brew install --cask slack
brew install --cask telegram
brew install --cask brave-browser
