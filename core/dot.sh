#!/usr/bin/env bash

dot_list_contexts() {
	find "$DOTFILES" -mindepth 3 -maxdepth 3 -path "*/*/main.sh" -type f 2>/dev/null |
		sed 's|.*/\([^/]*\)/[^/]*/main\.sh|\1|' |
		sort -u
}

dot_list_context_scripts() {
	local context="$1"

	find "$DOTFILES/$context" -mindepth 2 -maxdepth 2 -path "*/main.sh" -type f 2>/dev/null |
		sed 's|.*/\([^/]*\)/main\.sh|\1|' |
		sort -u
}
