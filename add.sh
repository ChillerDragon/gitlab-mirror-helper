#!/bin/bash

function show_help() {
	echo "usage: add.sh GITHUB_URL"
}

function add() {
	local github_url="$1"

	if [[ ! "$github_url" =~ ^(git@|https://)github.com[:/]([a-zA-Z0-9_-]+)/([a-zA-Z0-9_-]+)(.git)?$ ]]
	then
		echo "Error: invalid github url '$github_url'"
		echo "       only the git@github.com:org/repo.git"
		echo "       format is supported"
		exit 1
	fi

	echo "Adding repo '$github_url' ..."
	echo "  orga: ${BASH_REMATCH[2]}"
	echo "  repo: ${BASH_REMATCH[3]}"
}

if [ "$#" == "0" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
then
	show_help
	exit
fi

add "$1"

