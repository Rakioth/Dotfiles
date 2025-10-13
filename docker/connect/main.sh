#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

HELP="Usage:
  connect [<container>]
"

if ! command -v docker &>/dev/null; then
	output_error "Docker Desktop is not installed."
	exit 1
fi

selected=""
if [[ $# -gt 0 ]]; then
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo "$HELP"
		exit 0
	fi

	selected="$1"
else
	options=()
	mapfile -t options < <(docker ps -a --format "{{.Names}}" | sort -u)

	if [[ ${#options[@]} -eq 0 ]]; then
		echo "🔍 No containers found"
		exit 0
	fi

	containers_label=$(gum style --foreground "$PRIMARY_COLOR" container)
	selected=$(gum_filter --header "🐳 Select the $containers_label to connect: " "${options[@]}")
fi

[[ -z "$selected" ]] && exit 0

status=$(docker ps --filter "name=^${selected}$" --format "{{.Names}}")
if [[ -z "$status" ]]; then
	container_label=$(gum style --foreground "$SECONDARY_COLOR" "$selected")
	if ! gum spin --spinner globe --title "Starting $container_label..." -- docker start "$selected"; then
		output_error "Container '$selected' could not be started."
		exit 1
	fi
fi

docker exec -it "$selected" bash || docker exec -it "$selected" sh
