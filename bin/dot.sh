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
		script)
			shift
			bash "$DOTFILES/scripts/bootstrap.sh" $@
			;;
		*)
			\cat <<EOF
Usage:
  dot [<command>]

Commands:
  import      Install packages.
  symlink     Apply symlinks.
  script      Run scripts.

EOF
			;;
	esac
}

dot_completer() {
	compadd import symlink script
}

compdef dot_completer dot
