#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

HELP="Usage:
  search <package>
"

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
	echo "$HELP"
	exit 1
fi

options=()
mapfile -t options < <(yay -Ssq "$1" 2>/dev/null | grep -v '^ ->' | sort -u)

if [[ ${#options[@]} -eq 0 ]]; then
	echo "🔍 No packages found"
	exit 0
fi

packages_label=$(gum style --foreground "$PRIMARY_COLOR" package)
selected=$(gum_filter --select-if-one --header "📦 Select the $packages_label to install: " "${options[@]}")

[[ -z "$selected" ]] && exit 0

package_label=$(gum style --foreground "$SECONDARY_COLOR" "$selected")

if yay -Qq "$selected" &>/dev/null; then
	echo "🎉 Package already installed: $package_label"
	exit 0
fi

gum_sudo

if gum spin --spinner moon --title "Installing $package_label..." -- yay -S --noconfirm "$selected"; then
	echo "✅ Package successfully installed: $package_label"
else
	echo "🚫 Package could not be installed: $package_label"
fi
