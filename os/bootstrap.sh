#!/usr/bin/env bash

set -o pipefail

# Script variables
SCRIPT_NAME="Yay Importer"
SCRIPT_VERSION="v1.0.1"
SCRIPT_LOG="$HOME/dotfiles.log"

# Script colors
PURPLE="#ce3ed6"
VIOLET="#c698f2"
GREEN="#6dca7b"
BLUE="#11a8cd"
RED='\033[0;31m'
RESET='\033[0m'

# Script values
declare -A custom_packages=(
	["custom-nvchad"]="$HOME/.config/nvim/lua/core"
)
custom_packages_path="$DOTFILES/os/linux/custom"
default_packages_file="$DOTFILES/os/linux/Yayfile"
packages_file=""

# Logger
function logger() {
	gum log --file "$SCRIPT_LOG" --time timeonly --level "$1" --prefix="$SCRIPT_NAME" --structured "$2" "${@:3}"
}

# Helper
function default_help() {
	\cat <<EOF
Usage:
  import [<flag>]

Flags:
  -h, --help       Show context-sensitive help.
  -v, --version    Print the version number.
  -f, --file       Installs all the packages in a file.
                   Defaults to: $default_packages_file

EOF
}

function check_custom_package() {
	package=$1
	is_already_installed=false
	install_path="${custom_packages[$package]}"

	if [ -n "$install_path" -a -d "$install_path" ]; then
		is_already_installed=true
	fi

	echo $is_already_installed
}

function get_custom_package() {
	package=$1
	parsed_package="${package#custom-}"
	echo "${custom_packages_path}/${parsed_package}.sh"
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
			packages_file=$(gum file --cursor="❯" --height=10 --file --no-show-help --cursor.foreground=$PURPLE --symlink.foreground=$BLUE --selected.foreground="" --directory.foreground=$VIOLET --file.foreground=$GREEN "$(dirname "$default_packages_file")")
			;;
		*)
			default_help
			exit 1
			;;
	esac
fi

# If packages file is not specified, use the default location
if [ -z "$packages_file" ]; then
	packages_file="$default_packages_file"
fi

# Check if the packages file exists
if [ ! -f "$packages_file" ]; then
	if [ "$packages_file" == "$default_packages_file" ]; then
		logger warn "Default packages file not found" file $default_packages_file
		default_help
	else
		echo -e "${RED}File does not exist: $packages_file${RESET}"
	fi
	exit 1
fi

# Filter out the installed packages
installed_packages_list=$(/usr/sbin/yay -Qq)
not_installed_packages_list=$(grep -vFxf <(echo "$installed_packages_list") $packages_file)

filtered_not_installed_list=""
while IFS= read -r package; do
	is_already_installed=$(check_custom_package "$package")

	if [ "$is_already_installed" == false ]; then
		filtered_not_installed_list+="$package"$'\n'
	fi
done <<< "$not_installed_packages_list"

# If all the packages are already installed, exit
if [ -z "$filtered_not_installed_list" ]; then
	echo "🤝 No packages to install"
	exit 0
fi

# Choose the packages to install
packages_label=$(gum style --foreground=$PURPLE packages)
chosen_packages=$(gum filter --no-limit --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --selected-indicator.foreground=$VIOLET --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="🎯 Select the $packages_label to install: " --header.foreground="" --height=10 $filtered_not_installed_list)

if [ -z "$chosen_packages" ]; then
	exit 0
fi

# Install the chosen packages
while IFS= read -r package; do
	package_label=$(gum style --foreground=$VIOLET $package)
	package_installer="/usr/sbin/yay -Syyu --noconfirm $package"

	is_package_available=$(/usr/sbin/yay -Ssq "$package")
	custom_package_path=$(get_custom_package "$package")

	if [ -f "$custom_package_path" ]; then
		package_installer="bash $custom_package_path"
	elif [ -z "$(echo "$is_package_available" | grep "$package")" ]; then
		logger warn "Package not available" package $package
		echo "⚠️ Package not available: $package_label"
		continue
	fi

	eval "$package_installer"
done <<< "$chosen_packages"
