function upload_item() {
	curl -sF "file=@$1" 0x0.st
}

function git_fuzzy_add() {
	git add $(git ls-files --modified --others --exclude-standard | fzf --multi --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}")
}

function git_fuzzy_remove() {
	git reset HEAD $(git diff --cached --name-only --relative | fzf --multi --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}")
}

function git_commit_all() {
	git add -A && git commit -m "$*"
}

function git_commit_push() {
	git commit -m "$*" && git push
}

function git_clone() {
	repoPath=$1
	IFS='/' read -rA splitPath <<< "$repoPath"
	shift

	if [ "${#splitPath[@]}" -lt 3 ]; then
		git clone "https://github.com/$repoPath.git" --depth 1 $@
		return
	fi

	subdirectory=$(IFS='/'; echo "${splitPath[*]:2}")

	git clone "https://github.com/${splitPath[1]}/${splitPath[2]}.git" --depth 1 --no-checkout $@
	if [ $? -ne 0 ]; then
		return
	fi

	cd "${splitPath[2]}"
	git sparse-checkout set "$subdirectory"
	git checkout
	cd ..
}
