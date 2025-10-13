#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

HELP="Usage:
  dot <context> <script> [<args>...]
"

if [[ $# -lt 2 ]]; then
	echo "$HELP"
	exit 1
fi

context="$1"
script="$2"
shift 2

script_path="$DOTFILES/$context/$script/main.sh"

if [[ ! -f "$script_path" ]]; then
	output_error "Script '$script' not found in context '$context'."
	exit 1
fi

"$script_path" "$@"
