#!/usr/bin/env bash

PRIMARY_COLOR="#ce3ed6"
SECONDARY_COLOR="#c698f2"
PROMPT_SYMBOL="❯"

gum_filter() {
	local primary_color="$PRIMARY_COLOR"
	local secondary_color="$SECONDARY_COLOR"
	local prompt_symbol="$PROMPT_SYMBOL"
	local args=()

	while [[ $# -gt 0 ]]; do
		case $1 in
		--primary-color)
			primary_color="$2"
			shift 2
			;;
		--secondary-color)
			secondary_color="$2"
			shift 2
			;;
		--prompt-symbol)
			prompt_symbol="$2"
			shift 2
			;;
		*)
			args+=("$1")
			shift
			;;
		esac
	done

	gum filter "${args[@]}" \
		--no-show-help --no-fuzzy \
		--prompt.foreground "$primary_color" \
		--indicator.foreground "$primary_color" \
		--match.foreground "$primary_color" \
		--selected-indicator.foreground "$secondary_color" \
		--cursor-text.foreground "$secondary_color" \
		--text.foreground "240" \
		--header.foreground "" \
		--prompt "$prompt_symbol " \
		--placeholder "Search..." \
		--height 10
}

gum_sudo() {
	local primary_color="$PRIMARY_COLOR"
	local prompt_symbol="$PROMPT_SYMBOL"
	local args=()

	while [[ $# -gt 0 ]]; do
		case $1 in
		--primary-color)
			primary_color="$2"
			shift 2
			;;
		--prompt-symbol)
			prompt_symbol="$2"
			shift 2
			;;
		*)
			args+=("$1")
			shift
			;;
		esac
	done

	if command sudo -n true 2>/dev/null; then
		return 0
	fi

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

		if gum input "${args[@]}" \
			--no-show-help --password \
			--prompt.foreground "$primary_color" \
			--cursor.foreground "" \
			--prompt "$prompt_symbol " \
			--placeholder "$placeholder" |
			command sudo -S true 2>/dev/null; then
			return 0
		fi
	done

	return 1
}
