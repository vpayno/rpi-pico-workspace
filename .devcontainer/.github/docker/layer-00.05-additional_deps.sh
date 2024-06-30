#!/bin/bash
#
# .github/docker/layer-00.05-additional_deps.sh
#

set -o pipefail

# this path from inside the container
# shellcheck disable=SC1091
. /.github/docker/include

# shellcheck disable=SC1091
source /.github/citools/includes/wrapper-library || exit

main() {
	declare -i retval=0

	layer_begin "${0}" "$@"

	echo Running: sudo apt update
	time sudo apt update || track_errors
	printf "\n"

	local PACKAGES
	PACKAGES=(
		libcurl4
		libcurl4-doc
		libcurl4-openssl-dev
		libfontconfig1-dev
		libfreetype6-dev
		libfribidi-dev
		libharfbuzz-dev
		libjpeg-dev
		libpng-dev
		libtiff5-dev
		wamerican-huge
	)

	echo Running: sudo apt install -y "${PACKAGES[@]}"
	time sudo apt install -y "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: sudo apt-mark manual "${PACKAGES[@]}"
	time sudo apt-mark manual "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: sudo select-default-wordlist --show-choices
	time sudo select-default-wordlist --show-choices
	printf "\n"

	echo Running: sudo select-default-wordlist --set-default=american-huge
	time sudo select-default-wordlist --set-default=american-huge
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

main "${@}" |& tee "${HOME}"/layer-00.05-additional_deps.log
