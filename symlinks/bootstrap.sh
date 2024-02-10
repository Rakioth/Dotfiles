#!/usr/bin/env bash

set -o pipefail

# Script variables
SCRIPT_NAME="Symlinks Applier"
SCRIPT_VERSION="v1.0.0"
SCRIPT_LOG="$HOME/dotfiles.log"

# Script colors
PURPLE="#ce3ed6"
VIOLET="#c698f2"
GREEN="#6dca7b"
BLUE="#11a8cd"
RED='\033[0;31m'
RESET='\033[0m'

# Script values
dotbot_path="$DOTFILES/modules/dotbot/bin/dotbot"
default_symlinks_file="$DOTFILES/symlinks/conf.linux.yaml"
symlinks_file=""

# Logger
function logger() {
	gum log --file "$SCRIPT_LOG" --time timeonly --level "$1" --prefix="$SCRIPT_NAME" --structured "$2" "${@:3}"
}

# Helper
function default_help() {
	\cat <<EOF
Usage:
  symlink [<flag>]

Flags:
  -h, --help       Show context-sensitive help.
  -v, --version    Print the version number.
  -f, --file       Applies all the symlinks in a file.
                   Defaults to: $default_symlinks_file

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
		-f | --file)
			symlinks_file=$(gum file --cursor="❯" --height=10 --file --cursor.foreground=$PURPLE --symlink.foreground=$BLUE --selected.foreground="" --directory.foreground=$VIOLET --file.foreground=$GREEN "$(dirname "$default_symlinks_file")")
			;;
		*)
			default_help
			exit 1
			;;
	esac
fi

# If symlinks file is not specified, use the default location
if [ -z "$symlinks_file" ]; then
	symlinks_file="$default_symlinks_file"
fi

# Check if the symlinks file exists
if [ ! -f "$symlinks_file" ]; then
	if [ "$symlinks_file" == "$default_symlinks_file" ]; then
		logger warn "Default packages file not found" file $default_symlinks_file
		default_help
	else
		echo -e "${RED}File does not exist: $symlinks_file${RESET}"
	fi
	exit 1
fi

# Apply the symlinks
symlinks_label=$(gum style --foreground=$VIOLET symlinks)
gum spin --spinner moon --title "Applying $symlinks_label..." --show-output -- python $dotbot_path -d $DOTFILES -c $symlinks_file
