function upload_item() {
	curl -sF "file=@$1" https://0x0.st
}

function git_commit_all() {
	git add -A && git commit -m "$*"
}

function git_clone() {
	repoPath=$1
	IFS='/' read -rA splitPath <<< "$repoPath"

	if [ "${#splitPath[@]}" -lt 3 ]; then
		git clone "https://github.com/$repoPath.git" --depth 1
		return
	fi

	subdirectory=$(IFS='/'; echo "${splitPath[*]:2}")

	git clone "https://github.com/${splitPath[1]}/${splitPath[2]}.git" --depth 1 --no-checkout
	if [ $? -ne 0 ]; then
		return
	fi

	cd "${splitPath[2]}"
	git sparse-checkout set "$subdirectory"
	git checkout
	cd ..
}
