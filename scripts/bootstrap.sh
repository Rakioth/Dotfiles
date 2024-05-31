#!/usr/bin/env bash

set -o pipefail

# Script variables
SCRIPT_NAME="Script Manager"
SCRIPT_VERSION="v1.0.0"
SCRIPT_LOG="$HOME/dotfiles.log"

# Script colors
PURPLE="#ce3ed6"
VIOLET="#c698f2"

# Script values
scripts_path="$DOTFILES/scripts"
scripts_files=$(find "$scripts_path" -name "*.sh" ! -name "bootstrap.sh")

# Logger
function logger() {
	gum log --file "$SCRIPT_LOG" --time timeonly --level "$1" --prefix="$SCRIPT_NAME" --structured "$2" "${@:3}"
}

# Helper
function default_help() {
	\cat <<EOF
Usage:
  script [<flag>]

Flags:
  -h, --help       Show context-sensitive help.
  -v, --version    Print the version number.

EOF
}

# Arguments
if [ $# -gt 0 ]; then
	case "$1" in
		-h | --help)
			default_help
			exit 0
			;;
		-v | --version)
			echo "$SCRIPT_NAME $SCRIPT_VERSION"
			exit 0
			;;
		*)
			default_help
			exit 1
			;;
	esac
fi

# Choose the scripts to run
scripts=()
while IFS= read -r script; do
	scripts+="$(basename "${script%.sh}") "
done <<< "$scripts_files"
scripts_label=$(gum style --foreground=$PURPLE scripts)
chosen_scripts=$(gum filter --no-limit --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --selected-indicator.foreground=$VIOLET --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="📝 Select the $scripts_label you want to run: " --header.foreground="" --height=10 $scripts)

if [ -z "$chosen_scripts" ]; then
	exit 0
fi

# Run the chosen scripts
while IFS= read -r script; do
	script_label=$(gum style --foreground=$VIOLET $script)
	gum spin --spinner="monkey" --title="Running $script_label..." -- bash "$scripts_path/$script.sh"
	logger debug "Script run" script $script
done <<< "$chosen_scripts"
