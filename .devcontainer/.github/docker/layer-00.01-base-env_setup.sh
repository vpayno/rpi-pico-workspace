#!/bin/sh
#
# .github/docker/layer-00.01-base-env_setup.sh
#

# this path from for the container
# shellcheck disable=SC1091
. /.github/docker/include

main() {
	layer_begin "${0}" "$@"

	echo Adding ~/.bash_profile that sources ~/.profile
	tee "${HOME}"/.bash_profile <<-EOF
		. "\${HOME}"/.profile
	EOF
	printf "\n"

	echo Copying ~/.bash_profile to /etc/skel/.bash_profile
	cp -v "${HOME}"/.bash_profile /etc/skel/
	printf "\n"

	layer_end "${0}" "$@"
}

main "${@}" 2>&1 | tee "${HOME}"/layer-00.01-base-env_setup.log
