#!/bin/bash
#
# .github/docker/layer-09.00-devcontainer-nodejs.sh
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
		curl
		wget
	)

	declare -a MODULES
	MODULES=(
		cspell
		eslint
		eslint-config-prettier
		js-beautify
		json2yaml
		jsonlint
		markdownlint-cli
		prettier
		write-good
		yarn
	)

	echo Running: apt update
	time apt update || track_errors
	printf "\n"

	echo Running: sudo apt install -y "${PACKAGES[@]}"
	time sudo apt install -y "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: sudo apt-mark manual "${PACKAGES[@]}"
	time sudo apt-mark manual "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: curl -fsSL https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-installer \| bash
	time curl -fsSL https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-installer | bash || track_errors
	printf "\n"

	echo Running: mv -v "${HOME}"/.nodenv /usr/local/nodenv
	mv -v "${HOME}"/.nodenv /usr/local/nodenv || track_errors
	printf "\n"

	echo Running: ln -vs /usr/local/nodenv "${HOME}"/.nodenv
	ln -vs /usr/local/nodenv "${HOME}"/.nodenv || track_errors
	printf "\n"

	echo Running: ln -vs /usr/local/nodenv /etc/skel/.nodenv
	ln -vs /usr/local/nodenv /etc/skel/.nodenv || track_errors
	printf "\n"

	echo Checking installation:
	ls -lh /usr/local/ /usr/local/nodenv/ "${HOME}"/.nodenv /etc/skel/.nodenv || track_errors
	printf "\n"

	printf "Configuring Shell: "
	tee /etc/profile.d/nodejs.sh <<-EOF
		#
		# /etc/profile.d/nodejs.sh
		#

		export NODEJS_LTS_SERIES=20
		export NODENV_ROOT=/usr/local/nodenv
		export PATH="\${NODENV_ROOT}/bin:\${NODENV_ROOT}/shims:\${PATH}"

		eval "\$(nodenv init -)"
	EOF
	printf "done\n"

	echo Adding source /etc/profile.d/nodejs.sh to ~/.bashrc and /etc/skel/.bashrc
	echo '. /etc/profile.d/nodejs.sh' | tee -a "${HOME}/.bashrc" | tee -a /etc/skel/.bashrc
	printf "\n"

	echo Running: source /etc/profile.d/nodejs.sh
	# shellcheck disable=SC1091
	source /etc/profile.d/nodejs.sh || track_errors
	printf "\n"

	if [[ ! -d $(nodenv root)/plugins/node-build ]]; then
		echo Running: git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build
		time git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build || track_errors
		printf "\n"
	fi

	NODEJS_VERSION="$(nodenv install --list | grep "^${NODEJS_LTS_SERIES}" | sort -V | tail -n 1)"

	echo Running: nodenv install "${NODEJS_VERSION}"
	time nodenv install "${NODEJS_VERSION}" || track_errors
	printf "\n"

	echo Running: nodenv global "${NODEJS_VERSION}"
	time nodenv global "${NODEJS_VERSION}" || track_errors
	printf "\n"

	echo Running: npm install --global "${MODULES[@]}"
	time npm install --global "${MODULES[@]}" || exit
	printf "\n"

	echo Running: source /etc/profile.d/nodejs.sh
	# shellcheck disable=SC1091
	source /etc/profile.d/nodejs.sh || track_errors
	printf "\n"

	echo Running: chgrp -R adm /usr/local/nodenv
	chgrp -R adm /usr/local/nodenv || track_errors
	printf "\n"

	echo Running: setfacl -RPdm g:adm:w /usr/local/nodenv
	setfacl -RPdm g:adm:w /usr/local/nodenv || track_errors
	printf "\n"

	echo Running: curl -fsSL https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-doctor \| bash
	time curl -fsSL https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-doctor | bash || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

main "${@}" |& tee "${HOME}"/layer-09.00-devcontainer-nodejs.log
