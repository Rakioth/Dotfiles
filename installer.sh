#!/usr/bin/env bash

# Script colors
ANSI_VIOLET='\033[38;2;198;152;242m'
ANSI_RESET='\033[0m'

# Install yay
sudo pacman -S --needed git base-devel --noconfirm > /dev/null 2>&1 && git clone https://aur.archlinux.org/yay.git > /dev/null 2>&1 && cd yay && makepkg -si --noconfirm > /dev/null 2>&1
if ! which yay >/dev/null 2>&1; then
	echo -e "❌ ${ANSI_VIOLET}Yay${ANSI_RESET} could not be installed"
	exit 1
fi
echo -e "📦 ${ANSI_VIOLET}Yay${ANSI_RESET} installed"

# Install zsh
yay -S zsh zsh-completions --noconfirm > /dev/null 2>&1
if ! which zsh >/dev/null 2>&1; then
	echo -e "❌ ${ANSI_VIOLET}Zsh${ANSI_RESET} could not be installed"
	exit 1
fi
echo -e "🐚 ${ANSI_VIOLET}Zsh${ANSI_RESET} installed"

# Install gum
yay -S gum --noconfirm > /dev/null 2>&1
if ! which gum >/dev/null 2>&1; then
	echo -e "❌ ${ANSI_VIOLET}Gum${ANSI_RESET} could not be installed"
	exit 1
fi
echo -e "🎀 ${ANSI_VIOLET}Gum${ANSI_RESET} installed"

# Install git
yay -S git --noconfirm > /dev/null 2>&1
if ! which git >/dev/null 2>&1; then
	echo -e "❌ ${ANSI_VIOLET}Git${ANSI_RESET} could not be installed"
	exit 1
fi
echo -e "🐙 ${ANSI_VIOLET}Git${ANSI_RESET} installed"

# Install python
yay -S python --noconfirm > /dev/null 2>&1
if ! which python >/dev/null 2>&1; then
	echo -e "❌ ${ANSI_VIOLET}Python${ANSI_RESET} could not be installed"
	exit 1
fi
echo -e "🐍 ${ANSI_VIOLET}Python${ANSI_RESET} installed"

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
