#!/bin/bash
#
# .github/docker/layer-35.00-tools-tailscale.sh
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
		tailscale
	)

	echo Running: curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg \| sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg \>/dev/null
	curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null || track_errors
	printf "\n"

	echo Running: curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list \| sudo tee /etc/apt/sources.list.d/tailscale.list
	curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list || track_errors
	printf "\n"

	echo Running: apt update
	time apt update || track_errors
	printf "\n"

	echo Running: apt install -y "${PACKAGES[@]}"
	time apt install -y "${PACKAGES[@]}" || track_errors
	printf "\n"

	if command -v go >&/dev/null; then
		declare -a GO_PKGS
		GO_PKGS=(
			golang.zx2c4.com/wireguard@latest
		)

		declare url
		for url in "${GO_PKGS[@]}"; do
			echo Running: go install "${url}"
			go install "${url}" || track_errors
			printf "\n"
		done
	else
		printf "\n"
		printf "Go not found, skipping installation of extra packages.\n"
		printf "\n"
	fi

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

time main "${@}" |& tee "${HOME}"/layer-35.00-tools-tailscale.log
