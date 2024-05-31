function yay_clean() {
	PURPLE="#ce3ed6"
	VIOLET="#c698f2"

	if [ $# -gt 0 ]; then
		chosen_packages=$@
	else
		packages=$(/usr/sbin/yay -Qq)
		if [ -z "$packages" ]; then
			echo "🔍 No packages found"
			return
		fi

		packages_label=$(gum style --foreground=$PURPLE packages)
		chosen_packages=$(gum filter --no-limit --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --selected-indicator.foreground=$VIOLET --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="🗑️ Select the $packages_label to uninstall: " --header.foreground="" --height=10 $packages)
	fi

	if [ -z "$chosen_packages" ]; then
		return
	fi

	echo "$chosen_packages" | xargs /usr/sbin/yay -Runs --noconfirm
}
