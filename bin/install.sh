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
brew install fd
brew install fish
brew install fnm
brew install fzf
brew install gh
brew install gdu
brew install git
# brew install gitui
# brew install git-delta
# brew install glow
# brew install gum
brew install jq
# brew install lazydocker
# brew install lazygit
brew install lsd
brew install mackup
brew install neofetch
brew install neovim
brew install pgcli
brew install ripgrep
brew install starship
brew install tealdeer
brew install tmux
brew install pnpm
# brew install yazi
# brew install zellij
brew install zoxide
pnpm i -g fkill-cli

# brew tap federico-terzi/espanso
# brew install espanso

brew install skhd
skhd --start-service
brew install yabai
yabai --start-service

# mackup
cp ~/projects/r4zendotdev/dotfiles/.mackup.cfg ~/.mackup.cfg
mackup restore

# fisher https://github.com/jorgebucaran/fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install FabioAntunes/fish-nvm edc/bass franciscolourenco/done

# casks
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
# brew install --cask 1password
brew install --cask arc
brew install --cask alacritty
brew install --cask raycast
brew install --cask discord          
# brew install --cask fantastical      
brew install --cask obsidian         
brew install --cask postman          
brew install --cask slack
brew install --cask wezterm
