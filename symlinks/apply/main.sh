#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

CONFIG="link.linux.yml"
HELP="Usage:
  apply [<links>...]
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
	mapfile -t options < <(find "$DOTFILES" -mindepth 3 -maxdepth 3 -path "*/*/$CONFIG" -type f 2>/dev/null |
		sed 's|.*/\([^/]*\)/[^/]*\.yml|\1|' |
		sort -u)

	symlinks_label=$(gum style --foreground "$PRIMARY_COLOR" symlinks)
	mapfile -t selected < <(gum_filter --no-limit --header "🌐 Select the $symlinks_label to apply: " "${options[@]}" | sort -u)
fi

paths=()
for link in "${selected[@]}"; do
	config_path=$(find "$DOTFILES" -path "*/$link/$CONFIG" -type f 2>/dev/null | head -1)

	if [[ -z "$config_path" ]]; then
		output_error "Link '$link' not found."
		exit 1
	fi

	paths+=("$config_path")
done

if [[ ${#paths[@]} -gt 0 ]]; then
	symlinks_label=$(gum style --foreground "$SECONDARY_COLOR" symlinks)
	gum spin --spinner moon --title "Applying $symlinks_label..." --show-output --show-error -- \
		python "$DOTFILES/modules/dotbot/bin/dotbot" \
		--base-directory "$DOTFILES" \
		--config-file "$DOTFILES/symlinks/defaults.yml" \
		"${paths[@]}" \
		--verbose --force-color
fi
