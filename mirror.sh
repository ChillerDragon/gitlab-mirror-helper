#!/bin/bash

function is_mirror_repo() {
	local dir="$1"
	pushd "$dir" &>/dev/null || exit 1
	git remote get-url mirror &>/dev/null || return 1
	git remote get-url origin &>/dev/null || return 1
	local mirror
	local origin
	mirror="$(git remote get-url mirror)"
	origin="$(git remote get-url origin)"
	if [[ ! "$mirror" =~ gitlab ]]
	then
		echo "Error: unsupported mirror url"
		echo "       $mirror"
		exit 1
	fi
	if [[ ! "$origin" =~ github ]]
	then
		echo "Error: unsupported origin url"
		echo "       $origin"
		exit 1
	fi
	popd &>/dev/null || exit 1
	return 0
}

function mirror_repo() {
	local dir="$1"
	pushd "$dir" &>/dev/null || exit 1
	local repo
	repo="${dir##*/}"
	echo "[*] mirroring '$repo' ..."
	git pull origin || exit 1
	git push mirror || exit 1
	popd &>/dev/null || exit 1
}

function scan_repos() {
	local dir
	for dir in ./*/*/
	do
		is_mirror_repo "$dir" || continue

		# strip last slash
		mirror_repo "${dir%/}"
	done
}

function sleep_hours() {
	local hours=$1
	local i
	for ((i=0;i<hours;i++))
	do
		sleep 1h
		printf .
	done
	echo ""
}

while true
do
	scan_repos

	echo "[*] wait 12 hours before next sync  "
	sleep_hours 12
done

