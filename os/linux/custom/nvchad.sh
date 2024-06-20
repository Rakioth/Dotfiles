#!/usr/bin/env bash

set -uo pipefail

# Script variables
SCRIPT_NAME="NvChad Installer"
SCRIPT_LOG="$HOME/dotfiles.log"
SCRIPT_SOURCE="NvChad/NvChad"

# Logger
function logger() {
	gum log --file "$SCRIPT_LOG" --time timeonly --level "$1" --prefix="$SCRIPT_NAME" --structured "$2" "${@:3}"
}

# Helper
function install_dependency() {
	package=$1

	is_package_installed=$(/usr/sbin/yay -Qq)

	if [ -n "$(echo "$is_package_installed" | grep "$package")" ]; then
		logger warn "Dependency already installed" package $package
		return 0
	fi

	/usr/sbin/yay -Syyu --noconfirm $package

	package_check=$(/usr/sbin/yay -Qq)

	if [ -n "$(echo "$package_check" | grep "$package")" ]; then
		logger warn "Dependency installed" package $package
	else
		logger error "Dependency could not be installed" package $package
		exit 1
	fi
}

install_dependency git
install_dependency make
install_dependency gcc
install_dependency ripgrep
install_dependency neovim
