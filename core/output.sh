#!/usr/bin/env bash

output_success() {
	local message="$1"
	local label="${2:-Success:}"

	echo -e "\033[0;32m$label\033[0m $message"
}

output_error() {
	local message="$1"
	local label="${2:-Error:}"

	echo -e "\033[0;31m$label\033[0m $message"
}
