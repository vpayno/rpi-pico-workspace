#!/bin/bash
#
# .github/docker/layer-02.00-git.sh
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

	declare -a PACKAGES
	PACKAGES=(
		git
		git-crypt
		git-extras
	)

	echo Running: sudo apt update
	time sudo apt update || track_errors
	printf "\n"

	echo Running: sudo apt install -y "${PACKAGES[@]}"
	time sudo apt install -y "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: sudo apt-mark manual "${PACKAGES[@]}"
	time sudo apt-mark manual "${PACKAGES[@]}" || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

main "${@}" |& tee "${HOME}"/layer-02.00-git.log
