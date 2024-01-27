dot() {
	case $1 in
		import)
			shift
			bash "$DOTFILES/os/bootstrap.sh" $@
			;;
		symlink)
			shift
			bash "$DOTFILES/symlinks/bootstrap.sh" $@
			;;
		*)
			\cat <<EOF
Usage:
  dot [<command>]

Commands:
  import      Install packages.
  symlink     Apply symlinks.

EOF
			;;
	esac
}

dot_completer() {
	compadd import symlink
}

compdef dot_completer dot
