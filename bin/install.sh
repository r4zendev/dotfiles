#/bin/bash

if [[ -z $(command -v brew) ]]; then
	echo "Install Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	printf 'Homebrew is already installed, skip it.\n'
fi

cd ~ && mkdir -p projects/r4zendotdev && cd projects/r4zendotdev
git clone git@github.com:razenization/dotfiles.git dotfiles

brew install bash
brew install bat
brew install btop
brew install oven-sh/bun/bun
brew install difftastic
brew install fd
brew install fnm
brew install fzf
brew install gh
brew install gdu
brew install git
brew install git-delta
brew install jordanbaird-ice
brew install jq
brew install lazydocker
brew install lazygit
brew install lsd
brew install mackup
brew install neofetch
brew install neovim
brew install orbstack
brew install pgcli
brew install ripgrep
brew install starship
brew install tealdeer
brew install tmux
brew install pnpm
brew install thefuck
brew install yazi
brew install yt-dlp
brew install zoxide
pnpm i -g fkill-cli

brew install zsh-autocomplete
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

brew install yabai
yabai --start-service

# fonts
brew tap homebrew/cask-fonts
brew install --cask font-monaspace

# casks
brew install --cask 1password
brew install --cask alacritty
brew install --cask hammerspoon
brew install --cask discord          
brew install --cask obsidian         
brew install --cask postman          
brew install --cask slack
