#!/bin/bash
#
# .github/docker/layer-99.00-summary.sh
#

set -o pipefail

# this path from for the container
# shellcheck disable=SC1091
. /.github/docker/include

# shellcheck disable=SC1091
source /.github/citools/includes/wrapper-library || exit

main() {
	declare -i retval=0

	layer_begin "${0}" "$@"

	printf "OS Info:\n"
	tail -n 1000 /etc/os-release /etc/debian_version | paste /dev/null -
	printf "\n"

	printf "Collecting apt installed packages:\n"
	echo Running: apt list --installed \> "${HOME}"/apt-pkgs-end.txt
	apt list --installed >"${HOME}"/apt-pkgs-end.txt
	printf "\n"

	printf "Show apt package diff:\n"
	echo Running: diff -uNr "${HOME}"/apt-pkgs-{start,end}.txt
	diff -uNr "${HOME}"/apt-pkgs-{start,end}.txt
	printf "\n"

	# shellcheck disable=SC1090
	source ~/.cargo/env || track_errors

	printf "Show cargo packages:\n"
	echo Running cargo install --list
	cargo install --list | paste /dev/null -
	printf "\n"

	#printf "Show golang packages:\n"
	#echo Running ls "$(go env GOPATH)/bin"
	## shellcheck disable=SC2012
	#ls "$(go env GOPATH)/bin/" | paste /dev/null -
	#printf "\n"

	printf "Show npm packages:\n"
	echo Running npm list --global
	npm list --global | paste /dev/null -
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

main "${@}" |& tee "${HOME}"/layer-99.00-devcontainer-summary.log

if [[ -n ${GITHUB_STEP_SUMMARY} ]]; then
	{
		printf "\`\`\`text\n"
		cat "${HOME}"/layer-15.00-devcontainer-rust.log
		printf "\`\`\`\n"
	} >>"${GITHUB_STEP_SUMMARY}"
fi
