#!/usr/bin/env bash

# Script colors
ANSI_VIOLET='\033[38;2;198;152;242m'
ANSI_RESET='\033[0m'

# Helper
function install_dependency() {
	packages=$1
	command=$2
	name=$3
	emoji=$4

	if which "$command" >/dev/null 2>&1; then
		echo -e "${emoji} ${ANSI_VIOLET}${name}${ANSI_RESET} already installed"
		return
	fi

	yay -S $packages --noconfirm > /dev/null 2>&1

	if which "$command" >/dev/null 2>&1; then
		echo -e "${emoji} ${ANSI_VIOLET}${name}${ANSI_RESET} installed"
	else
		echo -e "❌ ${ANSI_VIOLET}${name}${ANSI_RESET} could not be installed"
		exit 1
	fi
}

function install_yay() {
	if which yay >/dev/null 2>&1; then
		echo -e "📦 ${ANSI_VIOLET}Yay${ANSI_RESET} already installed"
		return
	fi

	sudo pacman -S --needed git base-devel --noconfirm > /dev/null 2>&1 && git clone https://aur.archlinux.org/yay.git > /dev/null 2>&1 && cd yay && makepkg -si --noconfirm > /dev/null 2>&1

	if which yay >/dev/null 2>&1; then
		echo -e "📦 ${ANSI_VIOLET}Yay${ANSI_RESET} installed"
	else
		echo -e "❌ ${ANSI_VIOLET}Yay${ANSI_RESET} could not be installed"
		exit 1
	fi
}

# Install yay
install_yay

# Install dependencies
install_dependency "zsh zsh-completions" "zsh" "Zsh" "🐚"
install_dependency "gum" "gum" "Gum" "🎀"
install_dependency "git" "git" "Git" "🐙"
install_dependency "python" "python" "Python" "🐍"

# Change default shell to zsh
echo "raksonme" | chsh -s /usr/bin/zsh
sudo chsh -s /usr/bin/zsh

# Zim installation
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
sudo curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | sudo zsh

# Install packages
bash "$DOTFILES/os/bootstrap.sh"
sudo bash "$DOTFILES/os/bootstrap.sh"

# Apply symlinks
bash "$DOTFILES/symlinks/bootstrap.sh"
sudo bash "$DOTFILES/symlinks/bootstrap.sh"
