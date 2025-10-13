#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELP="Usage:
  linux [<packages>...]
"

selected=()
if [[ $# -gt 0 ]]; then
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo "$HELP"
		exit 0
	fi

	mapfile -t selected < <(printf '%s\n' "$@" | sort -u)
else
	options=()
	mapfile -t options < <(sort -u <"$SCRIPT_ROOT/packages")
	packages_label=$(gum style --foreground "$PRIMARY_COLOR" packages)
	mapfile -t selected < <(gum_filter --no-limit --header "🎯 Select the $packages_label to install: " "${options[@]}" | sort -u)
fi

for package in "${selected[@]}"; do
	package_label=$(gum style --foreground "$SECONDARY_COLOR" "$package")

	if yay -Qq "$package" &>/dev/null; then
		echo "🎉 Package already installed: $package_label"
		continue
	fi

	gum_sudo

	package_installer="gum spin --spinner globe --title \"Installing $package_label...\" -- yay -S --noconfirm '$package'"
	status=$(yay -Ssq "^$package$")

	if [[ -z "$status" ]]; then
		package_installer="cd \"$SCRIPT_ROOT/$package\" && makepkg -csi --noconfirm &>/dev/null && printf \"\033[1A\033[2K\" && find . -maxdepth 1 ! -name 'PKGBUILD' -type f -delete"
	fi

	if eval "$package_installer"; then
		echo "✅ Package successfully installed: $package_label"
	else
		echo "🚫 Package could not be installed: $package_label"
	fi
done
