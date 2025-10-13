#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/core/main.sh"

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
	output_error "Not inside a Git repository."
	exit 1
fi

if command -v diny &>/dev/null; then
	git_root=$(git rev-parse --show-toplevel)
	diny_config_path="$git_root/.git/diny-config.json"

	if [[ ! -f "$diny_config_path" ]]; then
		cat >"$diny_config_path" <<-EOF
			{
			  "useConventional": true,
			  "useEmoji": false,
			  "tone": "professional",
			  "length": "normal"
			}
		EOF
	fi
fi

staged_files=$(git diff --name-only --cached)
if [[ -z "$staged_files" ]]; then
	echo "🔍 No changes to commit"
	exit 0
fi

declare -A EMOJI_MAP=(
	["build"]="🏗️"
	["chore"]="🔧"
	["ci"]="🚦"
	["docs"]="📝"
	["feat"]="✨"
	["fix"]="🐛"
	["perf"]="🧠"
	["refactor"]="🧩"
	["revert"]="💥"
	["style"]="💅"
	["test"]="🧪"
)

get_commit_emoji() {
	local commit_type="$1"
	local normalized_type="${commit_type,,}"

	for key in "${!EMOJI_MAP[@]}"; do
		if [[ "$normalized_type" == "$key"* ]]; then
			echo "${EMOJI_MAP[$key]}"
			return
		fi
	done

	echo "❓"
}

generated_message=""
generated_description=""

if command -v diny &>/dev/null; then
	commit_label=$(gum style --foreground "$SECONDARY_COLOR" commit)
	mapfile -t commit_output < <(gum spin --spinner globe --title "Generating $commit_label..." --show-output -- diny commit --print)
	generated_message="${commit_output[1]}"

	if [[ ${#commit_output[@]} -gt 2 ]]; then
		generated_description=$(printf '%s\n' "${commit_output[@]:2}" | sed '/^$/d')
	fi
else
	mapfile -t commit_options < <(printf '%s\n' "${!EMOJI_MAP[@]}" | sort -u)
	commit_label=$(gum style --foreground "$PRIMARY_COLOR" commit)
	commit_type=$(gum_filter --header "🔖 Select the $commit_label type: " "${commit_options[@]}")

	commit_scope=$(gum input --no-show-help \
		--prompt.foreground "$PRIMARY_COLOR" \
		--cursor.foreground "" \
		--prompt "$PROMPT_SYMBOL " \
		--placeholder "scope") || commit_scope=""

	if [[ -n "$commit_scope" ]]; then
		generated_message="$commit_type($commit_scope): "
	else
		generated_message="$commit_type: "
	fi
fi

commit_message=$(gum input --no-show-help \
	--prompt.foreground "$PRIMARY_COLOR" \
	--cursor.foreground "" \
	--prompt "$PROMPT_SYMBOL " \
	--placeholder "Summary of this change" \
	--value="$generated_message")

if [[ -z "$commit_message" ]]; then
	exit 1
fi

IFS=: read -r commit_type commit_content <<<"$commit_message"

scope=$(gum style --foreground "$SECONDARY_COLOR" "${commit_type}:")
emoji=$(get_commit_emoji "$commit_type")
header="$emoji $scope$commit_content"

commit_description=$(gum write --no-show-help --show-line-numbers \
	--header "$header"$'\n' \
	--prompt.foreground "$PRIMARY_COLOR" \
	--cursor-line-number.foreground "$SECONDARY_COLOR" \
	--line-number.foreground "240" \
	--cursor.foreground "" \
	--placeholder "Details of this change" \
	--value="$generated_description") || commit_description=""

echo

if ! gum confirm --no-show-help --prompt.italic \
	--selected.background "$PRIMARY_COLOR" \
	--prompt.foreground "" \
	"Commit changes?"; then
	exit 1
fi

git commit -m "$commit_message" -m "$commit_description"

if gum confirm --no-show-help --prompt.italic \
	--selected.background "$PRIMARY_COLOR" \
	--prompt.foreground "" \
	$'\n'"Push changes?"; then
	git push
fi
