#!/bin/sh
#
# .github/docker/layer-00.00-base-dependencies.sh
#

# this path from for the container
# shellcheck disable=SC1091
. /.github/docker/include

main() {
	layer_begin "${0}" "$@"

	# PACKAGES="acl apt-utils bash bsdextrautils coreutils curl jq moreutils nala sudo tmux tree util-linux vim-nox xq yq zx"
	PACKAGES="acl apt-utils bash coreutils curl jq moreutils sudo tmux tree util-linux vim-nox"

	printf "Collecting apt installed packages:\n"
	echo Running: apt list --installed \> "${HOME}"/apt-pkgs-start.txt
	apt list --installed >"${HOME}"/apt-pkgs-start.txt
	printf "\n"

	echo apt install -y "${PACKAGES}"
	# shellcheck disable=SC2086
	apt install -y ${PACKAGES} || exit
	printf "\n"

	echo apt-mark manual "${PACKAGES}"
	# shellcheck disable=SC2086
	apt-mark manual ${PACKAGES} || exit
	printf "\n"

	layer_end "${0}" "$@"
}

main "${@}" 2>&1 | tee "${HOME}"/layer-00.00-base-dependencies.log
