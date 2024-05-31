source ${DOTFILES}/package/yay/clean.sh
source ${DOTFILES}/package/yay/search.sh

yay() {
	case $1 in
		clean)
			shift
			yay_clean $@
			;;
		search)
			yay_search $2
			;;
		*)
			/usr/sbin/yay $@
			;;
	esac
}

yay_completer() {
	compadd clean search
}

compdef yay_completer yay
