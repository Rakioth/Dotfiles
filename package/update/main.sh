#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

HELP="Usage:
  update [<packages>...]
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
	mapfile -t options < <(yay -Quq | sort -u)

	if [[ ${#options[@]} -eq 0 ]]; then
		echo "🔍 No packages found"
		exit 0
	fi

	packages_label=$(gum style --foreground "$PRIMARY_COLOR" packages)
	mapfile -t selected < <(gum_filter --no-limit --header "♻️ Select the $packages_label to update: " "${options[@]}" | sort -u)
fi

for package in "${selected[@]}"; do
	package_label=$(gum style --foreground "$SECONDARY_COLOR" "$package")

	if ! yay -Quq "$package" &>/dev/null; then
		echo "🎉 Package already updated: $package_label"
		continue
	fi

	gum_sudo

	if gum spin --spinner moon --title "Updating $package_label..." -- yay -S --noconfirm "$package"; then
		echo "✅ Package successfully updated: $package_label"
	else
		echo "🚫 Package could not be updated: $package_label"
	fi
done
