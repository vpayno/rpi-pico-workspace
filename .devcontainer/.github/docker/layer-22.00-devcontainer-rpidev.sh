#!/bin/bash
#
# .github/docker/layer-22.00-devcontainer-rpidev.sh
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

	echo Running: /.github/citools/rpidev/rpidev-setup-install
	time /.github/citools/rpidev/rpidev-setup-install || track_errors
	printf "\n"

	echo Running: /.github/citools/rpidev/rpidev-setup-config
	time /.github/citools/rpidev/rpidev-setup-config || track_errors
	printf "\n"

	echo Adding source /etc/profile.d/rpidev.sh to ~/.bashrc and /etc/skel/.bashrc
	echo '. /etc/profile.d/rpidev.sh' | tee -a "${HOME}/.bashrc" | tee -a "${HOME}/.profile" | tee -a /etc/skel/.bashrc || track_errors
	printf "\n"

	echo Running: source /etc/profile.d/rpidev.sh
	# shellcheck disable=SC1091
	source /etc/profile.d/rpidev.sh || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

time main "${@}" |& tee "${HOME}"/layer-22.00-devcontainer-rpidev.log
