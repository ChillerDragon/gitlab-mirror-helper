#!/bin/bash

# could be configurable and then
# the script might be reusable
MIRROR_HOST=gitlab-MIRROR
MIRROR_HOST_HTTP=gitlab.com

SCRIPT_DIR="$(dirname "$0")"

function get_mapping() {
	local github_org="$1"
	grep "^$github_org," "$SCRIPT_DIR/mappings.csv" | cut -d',' -f2-
}

function show_help() {
	echo "usage: add.sh GITHUB_URL"
}

function add() {
	local github_url="$1"
	local mirror_url
	local mirror_url_http
	local org
	local repo

	if [[ ! "$github_url" =~ ^(git@|https://)github.com[:/]([a-zA-Z0-9_-]+)/([a-zA-Z0-9_-]+)(.git)?$ ]]
	then
		echo "Error: invalid github url '$github_url'"
		echo "       only the git@github.com:org/repo.git"
		echo "       format is supported"
		exit 1
	fi

	org="${BASH_REMATCH[2]}"
	repo="${BASH_REMATCH[3]}"

	local mapping
	mapping="$(get_mapping "$org")"
	if [ "$mapping" != "" ]
	then
		echo "[*] Exception mapping '$org' -> '$mapping'"
		org="$mapping"
	fi

	mirror_url="git@$MIRROR_HOST:$org/$repo.git"
	mirror_url_http="https://$MIRROR_HOST_HTTP/$org/$repo"

	if [ -d "$repo" ]
	then
		echo "Error: directory '$repo' already exists"
		echo "       todo support a --force in this case"
		exit 1
	fi
	if [ -d "$org/$repo" ]
	then
		echo "Error: directory '$org/$repo' already exists"
		echo "       todo support a --force in this case"
		exit 1
	fi

	echo "Adding repo '$github_url' ..."
	echo "  orga: $org"
	echo "  repo: $repo"
	echo "  mirr: $mirror_url"

	mkdir -p "$org"
	cd "$org" || exit 1
	git clone --recursive "$github_url" "$repo"
	cd "$repo" || exit 1
	git remote add mirror "$mirror_url"

	local branch
	# needs git 2.22
	if git branch --show-current &>/dev/null
	then
		branch="$(git branch --show-current)"
	else
		# fallback to this for old git
		if ! git rev-parse --abbrev-ref HEAD
		then
			# print the error message in case of non zero exit code:
			git rev-parse --abbrev-ref HEAD
			echo "Error: failed to get current branch"
			exit 1
		fi
		branch="$(git rev-parse --abbrev-ref HEAD)"
	fi
	if [ "$branch" == "" ]
	then
		echo "Error: failed to get current branch (empty)"
		exit 1
	fi

	git push mirror "$branch" || {
		echo "Error: failed to push";
		exit 1;
	}
	echo "[+] Mirrored to $mirror_url_http"
}

if [ "$#" == "0" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
then
	show_help
	exit
fi

add "$1"

