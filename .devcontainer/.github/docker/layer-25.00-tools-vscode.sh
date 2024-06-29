#!/bin/bash
#
# .github/docker/layer-25.00-tools-vscode.sh
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
		apt-transport-https
		ca-certificates
		gpg
		libc6
		libstdc++6
		tar
		wget
	)

	echo Running: apt install -y "${PACKAGES[@]}"
	time apt install -y "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: wget -qO- https://packages.microsoft.com/keys/microsoft.asc \| gpg --dearmor \| tee /tmp/packages.microsoft.gpg
	time wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /tmp/packages.microsoft.gpg || track_errors
	printf "\n"

	echo Running: install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	time install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg || track_errors
	printf "\n"

	# get list of available repos from: https://packages.microsoft.com/repos/
	echo Creating /etc/apt/sources.list.d/vscode.list
	local -a repos=("code")
	local repo
	for repo in "${repos[@]}"; do
		printf "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/%s stable main\n" "${repo}"
	done | tee /etc/apt/sources.list.d/vscode.list || track_errors
	printf "\n"

	echo Running: apt update
	time apt update || track_errors
	printf "\n"

	# echo Running: apt install -y code
	# time apt install -y code || track_errors
	# printf "\n"

	local latest_cs_ver
	local cpu_arch
	local cs_deb
	local cs_url

	latest_cs_ver="$(curl -sS https://api.github.com/repos/coder/code-server/releases/latest | jq -r .name)"

	cpu_arch="$(dpkg --print-architecture)"

	cs_deb="$(curl -sS https://api.github.com/repos/coder/code-server/releases/latest | jq -r '.assets[].name' | grep "${cpu_arch}.deb")"

	cs_url="https://github.com/coder/code-server/releases/download/${latest_cs_ver}/${cs_deb}"

	echo Running: wget --no-verbose --continue "${cs_url}" --output-document="/tmp/${cs_deb}"
	time wget --no-verbose --continue "${cs_url}" --output-document="/tmp/${cs_deb}" || track_errors
	printf "\n"

	echo Running: apt install -y "/tmp/${cs_deb}"
	time apt install -y "/tmp/${cs_deb}" || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

time main "${@}" |& tee "${HOME}"/layer-25.00-tools-vscode.log
