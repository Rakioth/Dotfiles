function yay_search() {
	PURPLE="#ce3ed6"
	VIOLET="#c698f2"

	packages=$(/usr/sbin/yay -Ssq $1)
	if [ -z "$packages" ]; then
		echo "🔍 No packages found"
		return
	fi

	packages_label=$(gum style --foreground=$PURPLE package)
	chosen_package=$(echo "$packages" | gum filter --select-if-one --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="🚀 Select the $packages_label to install: " --header.foreground="" --height=10)

	if [ -z "$chosen_package" ]; then
		return
	fi

	echo "$chosen_package" | xargs /usr/sbin/yay -Syyu --noconfirm
}
