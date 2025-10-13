#!/usr/bin/env bash

source "$DOTFILES/core/main.sh"

start_intellij() {
	local file_path
	file_path=$(find /mnt/c/Program\ Files\ \(x86\)/JetBrains/IntelliJ\ IDEA*/bin -name "idea64.exe" 2>/dev/null | head -1)
	(nohup "$file_path" "$@" </dev/null &>/dev/null &)
}

upload_item() {
	local file="$1"

	if [[ ! -f "$file" ]]; then
		output_error "File not found $file."
		return 1
	fi

	local upload_response
	upload_response=$(curl -s -w "%{http_code}" -F "file=@$file" 0x0.st)

	local status_code upload_url
	status_code=$(echo "$upload_response" | tail -1)
	upload_url=$(echo "$upload_response" | head -1)

	if [[ "$status_code" != "200" ]]; then
		output_error "Upload failed with status code $status_code."
		return 1
	fi

	if command -v clip.exe &>/dev/null; then
		echo -n "$upload_url" | clip.exe
	elif command -v xclip &>/dev/null; then
		echo -n "$upload_url" | xclip -selection clipboard
	elif command -v pbcopy &>/dev/null; then
		echo -n "$upload_url" | pbcopy
	else
		echo "$upload_url"
		output_error "No clipboard tool found."
		return 1
	fi

	output_success "URL copied to clipboard."
}

start_sudo() {
	gum_sudo

	if [[ "$1" == "su" ]]; then
		shift
		command sudo --preserve-env zsh "$@"
	else
		command sudo "$@"
	fi
}

git_remove() {
	local staged_files
	staged_files=$(git diff --name-only --cached 2>/dev/null) || {
		output_error "Not inside a Git repository."
		return $?
	}

	if [[ -z "$staged_files" ]]; then
		echo "🔍 No staged changes found"
		return 0
	fi

	local selected_files
	selected_files=$(printf '%s\n' "${staged_files[@]}" | sort -u | fzf --multi --preview="git diff HEAD --color=always -- {}")

	[[ -n "$selected_files" ]] && echo "$selected_files" | xargs git reset HEAD &>/dev/null
}

git_add() {
	local unstaged_files
	unstaged_files=$({ git diff --name-only 2>/dev/null && git ls-files --others --exclude-standard 2>/dev/null; }) || {
		output_error "Not inside a Git repository."
		return $?
	}

	if [[ -z "$unstaged_files" ]]; then
		echo "🔍 No unstaged changes found"
		return 0
	fi

	local selected_files
	selected_files=$(printf '%s\n' "${unstaged_files[@]}" | sort -u | fzf --multi --preview="git diff HEAD --color=always -- {}")

	[[ -n "$selected_files" ]] && echo "$selected_files" | xargs git add
}

git_commit() {
	git commit -m "$*"
}

git_commit_all() {
	git add -A && git commit -m "$*"
}

git_commit_push() {
	git commit -m "$*" && git push
}

git_commit_all_push() {
	git add -A && git commit -m "$*" && git push
}

git_clone() {
	local repo="$1"
	shift

	IFS='/' read -rA split_path <<<"$repo"

	if [[ ${#split_path[@]} -lt 3 ]]; then
		git clone "https://github.com/$repo.git" "$@"
		return $?
	fi

	local sparse_path="${split_path[*]:2}"
	sparse_path="${sparse_path// //}"

	git clone "https://github.com/${split_path[1]}/${split_path[2]}.git" --no-checkout "$@" || return $?

	(
		cd "${split_path[2]}" || return 1
		git sparse-checkout set "$sparse_path"
		git checkout
	)
}
