function yay_clean() {
	PURPLE="#ce3ed6"
	VIOLET="#c698f2"

	result=$(/usr/sbin/yay -Qq)

	chosen_packages=$(echo "$result" | gum filter --no-limit --prompt="❯ " --placeholder="Search..." --match.foreground=$PURPLE --prompt.foreground=$PURPLE --text.foreground=$VIOLET --indicator.foreground=$PURPLE --unselected-prefix.foreground=$VIOLET --selected-indicator.foreground=$PURPLE --cursor-text.foreground="" --height=10)

	if [ -z "$chosen_packages" ]; then
		return 0
	fi

	echo "$chosen_packages" | xargs /usr/sbin/yay -Runs --noconfirm
}
