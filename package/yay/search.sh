function yay_search() {
	PURPLE="#ce3ed6"
	VIOLET="#c698f2"

	result=$(/usr/sbin/yay -Ssq $1)

	if [ -z "$result" ]; then
        echo "🔍 No package found"
        return 0
    fi

	chosen_package=$(echo "$result" | gum filter --placeholder="Search..." --match.foreground=$PURPLE --prompt.foreground=$PURPLE --text.foreground=$VIOLET --indicator.foreground=$PURPLE --unselected-prefix.foreground=$VIOLET --selected-indicator.foreground=$PURPLE --cursor-text.foreground="" --height=10)

	if [ -z "$chosen_package" ]; then
		return 0
	fi

	echo "$chosen_package" | xargs /usr/sbin/yay -Syyu --noconfirm
}
