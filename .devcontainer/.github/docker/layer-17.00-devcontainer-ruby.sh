#!/bin/bash
#
# .github/docker/layer-17.00-devcontainer-ruby.sh
#

set -o pipefail

# https://apt.llvm.org/

# this path from for the container
# shellcheck disable=SC1091
. /.github/docker/include

# shellcheck disable=SC1091
source /.github/citools/includes/wrapper-library || exit

main() {
	declare -i retval=0

	layer_begin "${0}" "$@"

	echo Running: /.github/citools/ruby/ruby-setup-install
	time /.github/citools/ruby/ruby-setup-install || track_errors
	printf "\n"

	echo Running: /.github/citools/ruby/ruby-setup-config
	time /.github/citools/ruby/ruby-setup-config || track_errors
	printf "\n"

	echo Running: mv .rbenv /usr/local/rbenv
	time mv "${HOME}/.rbenv" /usr/local/rbenv || track_errors
	printf "\n"

	echo Running: ln -sv /usr/local/rbenv "${HOME}/.rbenv"
	ln -sv /usr/local/rbenv "${HOME}/.rbenv" || track_errors
	printf "\n"

	echo Running: ln -sv /usr/local/rbenv "/etc/skel/.rbenv"
	ln -sv /usr/local/rbenv "/etc/skel/.rbenv" || track_errors
	printf "\n"

	echo Checking installation:
	ls -lh /usr/local/ /usr/local/rbenv/ "${HOME}"/.rbenv /etc/skel/.rbenv
	printf "\n"

	printf "Configuring Shell: "
	tee /etc/profile.d/ruby.sh <<-EOF
		#
		# /etc/profile.d/ruby.sh
		#

		export PATH="/usr/local/rbenv/bin:/usr/local/rbenv/bin/shims:\${PATH}"

		eval "\$(rbenv init -)"
	EOF
	printf "done\n"

	echo Adding source /etc/profile.d/ruby.sh to ~/.bashrc and /etc/skel/.bashrc
	echo '. /etc/profile.d/ruby.sh' | tee -a "${HOME}/.bashrc" | tee -a /etc/skel/.bashrc
	printf "\n"

	echo Running: source /etc/profile.d/ruby.sh
	# shellcheck disable=SC1091
	source /etc/profile.d/ruby.sh || track_errors
	printf "\n"

	echo Running: chgrp -R adm /usr/local/rbenv
	chgrp -R adm /usr/local/rbenv || track_errors
	printf "\n"

	echo Running: setfacl -RPdm g:adm:w /usr/local/rbenv
	setfacl -RPdm g:adm:w /usr/local/rbenv || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

time main "${@}" |& tee "${HOME}"/layer-17.00-devcontainer-ruby.log
