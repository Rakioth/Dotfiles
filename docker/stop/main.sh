#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

HELP="Usage:
  stop [<containers>...]
"

if ! command -v docker &>/dev/null; then
	output_error "Docker Desktop is not installed."
	exit 1
fi

selected=()
if [[ $# -gt 0 ]]; then
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo "$HELP"
		exit 0
	fi

	mapfile -t selected < <(printf '%s\n' "$@" | sort -u)
else
	options=()
	mapfile -t options < <(docker ps --format "{{.Names}}" | sort -u)

	if [[ ${#options[@]} -eq 0 ]]; then
		echo "🔍 No containers found"
		exit 0
	fi

	containers_label=$(gum style --foreground "$PRIMARY_COLOR" containers)
	mapfile -t selected < <(gum_filter --no-limit --header "🐳 Select the $containers_label to stop: " "${options[@]}" | sort -u)
fi

for container in "${selected[@]}"; do
	container_label=$(gum style --foreground "$SECONDARY_COLOR" "$container")

	if gum spin --spinner globe --title "Stopping $container_label..." -- docker stop "$container"; then
		echo "✅ Container successfully stopped: $container_label"
	else
		echo "🚫 Container could not be stopped: $container_label"
	fi
done
