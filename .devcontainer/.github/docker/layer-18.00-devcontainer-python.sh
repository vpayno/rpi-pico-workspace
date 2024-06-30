#!/bin/bash
#
# .github/docker/layer-18.00-devcontainer-python.sh
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

	export PYENV_ROOT="/usr/local/pyenv"

	echo Running: /.github/citools/python/python-setup-install
	time /.github/citools/python/python-setup-install || track_errors
	printf "\n"

	echo Running: /.github/citools/python/python-setup-config
	time /.github/citools/python/python-setup-config || track_errors
	printf "\n"

	echo Running: ln -sv /usr/local/pyenv "${HOME}/.pyenv"
	ln -sv "${PYENV_ROOT}" "${HOME}/.pyenv" || track_errors
	printf "\n"

	echo Running: ln -sv /usr/local/pyenv "/etc/skel/.pyenv"
	ln -sv "${PYENV_ROOT}" "/etc/skel/.pyenv" || track_errors
	printf "\n"

	echo Checking installation:
	ls -lh /usr/local/ "${PYENV_ROOT}" "${HOME}"/.pyenv /etc/skel/.pyenv
	printf "\n"

	echo Adding source /etc/profile.d/python.sh to ~/.bashrc and /etc/skel/.bashrc
	echo '. /etc/profile.d/python.sh' | tee -a "${HOME}/.bashrc" | tee -a "${HOME}/.profile" | tee -a /etc/skel/.bashrc || track_errors
	printf "\n"

	echo Running: source /etc/profile.d/python.sh
	# shellcheck disable=SC1091
	source /etc/profile.d/python.sh || track_errors
	printf "\n"

	echo Running: chgrp -R adm /usr/local/pyenv
	chgrp -R adm "${PYENV_ROOT}" || track_errors
	printf "\n"

	echo Running: setfacl -RPdm g:adm:w /usr/local/pyenv
	setfacl -RPdm g:adm:w "${PYENV_ROOT}" || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

time main "${@}" |& tee "${HOME}"/layer-18.00-devcontainer-python.log
