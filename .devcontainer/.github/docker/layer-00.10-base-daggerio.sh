#!/bin/bash
#
# .github/docker/layer-00.10-base-daggerio.sh
#

set -o pipefail

# this path from for the container
# shellcheck disable=SC1091
. /.github/docker/include

# shellcheck disable=SC1091
source /.github/citools/includes/wrapper-library || exit

main() {
	layer_begin "${0}" "$@"

	echo curl -sSfL https://releases.dagger.io/dagger/install.sh \| sh
	curl -sSfL https://releases.dagger.io/dagger/install.sh | sh || track_errors
	printf "\n"

	layer_end "${0}" "$@"
}

main "${@}" |& tee "${HOME}"/layer-00.10-base-daggerio.log
