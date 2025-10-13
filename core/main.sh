#!/usr/bin/env bash

for file in "$DOTFILES/core"/*.sh; do
	[[ "$(basename "$file")" != "main.sh" ]] && source "$file"
done
