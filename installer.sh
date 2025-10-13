#!/usr/bin/env bash

set -euo pipefail

# Script colors/styles
RED="\033[0;31m"
GREEN="\033[0;32m"
PURPLE="\033[38;2;206;62;214m"
VIOLET="\033[38;2;198;152;242m"
NORMAL="\033[0m"
PROMPT="❯"

HEX_PURPLE="#ce3ed6"
HEX_VIOLET="#c698f2"
HEX_GREEN="#6dca7b"
HEX_BLUE="#11a8cd"

# Script values
DOTFILES_REPOSITORY="https://github.com/Rakioth/Dotfiles.git"
DOTFILES_ENV="DOTFILES"
DOTFILES_FOLDER=".dotfiles"
DOTFILES_PATH="$HOME/$DOTFILES_FOLDER"

# Script functions
output_success() {
	local message="$1"
	echo -e "   ${GREEN}${PROMPT}${NORMAL} $message"
}

output_error() {
	local message="$1"
	echo -e "   ${RED}${PROMPT}${NORMAL} $message"
	exit 1
}

request_sudo() {
	if sudo -n true 2>/dev/null; then
		return 0
	fi

	if command -v gum &>/dev/null; then
		for attempt in $(seq 1 3); do
			case $attempt in
			1)
				placeholder="Enter your password to continue"
				;;
			2)
				placeholder="Incorrect password - please try again"
				;;
			3)
				placeholder="Last chance - incorrect password will fail"
				;;
			esac

			if gum input --no-show-help --password \
				--prompt.foreground "$HEX_PURPLE" \
				--cursor.foreground "" \
				--prompt "$PROMPT " \
				--placeholder "$placeholder" |
				sudo -S true 2>/dev/null; then
				return 0
			fi
		done
	else
		sudo true || exit 1
		printf "\033[1A\033[2K"
		return 0
	fi

	exit 1
}

install_yay() {
	echo -e "📦 ${VIOLET}Installing${NORMAL} package: ${PURPLE}yay${NORMAL}"

	if command -v yay &>/dev/null; then
		output_success "Already installed"
		return 0
	fi

	request_sudo

	sudo pacman -S --needed git base-devel --noconfirm &>/dev/null
	git clone https://aur.archlinux.org/yay.git &>/dev/null

	(
		cd yay || exit 1
		makepkg -si --noconfirm &>/dev/null
		printf "\033[1A\033[2K"
		printf "\033[1A\033[2K"
	)

	rm -rf yay

	if command -v yay &>/dev/null; then
		output_success "Successfully installed"
	else
		output_error "Could not be installed"
	fi
}

install_package() {
	local emoji="$1"
	local package="$2"

	echo -e "$emoji ${VIOLET}Installing${NORMAL} package: ${PURPLE}$package${NORMAL}"

	if yay -Qq "$package" &>/dev/null; then
		output_success "Already installed"
		return 0
	fi

	request_sudo

	if yay -S --noconfirm "$package" &>/dev/null; then
		output_success "Successfully installed"
	else
		output_error "Could not be installed"
	fi
}

get_dotfiles_path() {
	if gum confirm --no-show-help --prompt.italic \
		--selected.background "$HEX_PURPLE" --prompt.foreground "" \
		--default=false \
		"Change dotfiles location? (default ~/.dotfiles)"; then

		local location
		while true; do
			location=$(gum file "$HOME" --no-show-help \
				--cursor.foreground "$HEX_PURPLE" \
				--symlink.foreground "$HEX_BLUE" \
				--directory.foreground "$HEX_VIOLET" \
				--file.foreground "$HEX_GREEN" \
				--selected.foreground "" \
				--directory=true \
				--file=false \
				--cursor "$PROMPT" \
				--height 10)

			if [[ -d "$location" ]]; then
				echo "$location/$DOTFILES_FOLDER"
				break
			fi
		done
	else
		echo "$DOTFILES_PATH"
	fi
}

initialize_dotfiles() {
	local location="$1"

	request_sudo

	echo "$DOTFILES_ENV=$location" | sudo tee -a /etc/environment &>/dev/null
	echo "export $DOTFILES_ENV=$location" | sudo tee -a /etc/profile.d/dotfiles.sh &>/dev/null

	local dotfiles_label
	dotfiles_label=$(gum style --foreground "$HEX_VIOLET" "$DOTFILES_FOLDER")
	gum spin --spinner meter --spinner.foreground "$HEX_PURPLE" \
		--title "Cloning $dotfiles_label..." -- \
		git clone --recursive "$DOTFILES_REPOSITORY" "$location"
}

echo -e "${PURPLE}╭$(printf '%.0s─' {1..50})╮${NORMAL}"
echo -e "${PURPLE}│${NORMAL}              🥀 \033[3mDotfiles Installer\033[0m               ${PURPLE}│${NORMAL}"
echo -e "${PURPLE}╰$(printf '%.0s─' {1..50})╯${NORMAL}"
echo

# Install dependencies
install_yay
install_package "🐚" "zsh"
install_package "🎀" "gum"
install_package "🧬" "git"
install_package "🐍" "python"

echo
dotfiles_label=$(gum style --foreground "$HEX_VIOLET" "$DOTFILES_FOLDER")

# Handle dotfiles setup
dotfiles_root=""
if [[ -n "${!DOTFILES_ENV:-}" ]]; then
	echo "🎉 $dotfiles_label already cloned!"
	dotfiles_root="${!DOTFILES_ENV}"
else
	chosen_path=$(get_dotfiles_path)
	initialize_dotfiles "$chosen_path"
	echo "🎉 $dotfiles_label cloned!"
	dotfiles_root="$chosen_path"
fi

# Enable zsh as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
	sudo chsh -s /usr/bin/zsh "$USER"
fi

# Install packages
echo
"$dotfiles_root/os/linux/main.sh"

# Apply symlinks
echo
"$dotfiles_root/symlinks/apply/main.sh"
