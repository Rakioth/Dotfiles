source ${DOTFILES}/package/yay/clean.sh
source ${DOTFILES}/package/yay/search.sh

function yay() {
	case $1 in
		clean)
			yay_clean
			;;
		search)
			yay_search $2
			;;
		*)
			/usr/sbin/yay $@
			;;
	esac
}

function upload_item() {
	curl -sF "file=@$1" https://0x0.st
}

function git_commit_all() {
	git add -A && git commit -m "$*"
}

function git_clone() {
	git clone "https://github.com/$1.git"
}
