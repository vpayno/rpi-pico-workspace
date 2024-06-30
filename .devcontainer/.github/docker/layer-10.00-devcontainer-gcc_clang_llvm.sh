#!/bin/bash
#
# .github/docker/layer-10.00-devcontainer-gcc_clang_llvm.sh
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

	declare -a PACKAGES
	PACKAGES=(
		build-essential
		clangd-"${LLVM_VER}"
		clang-"${LLVM_VER}"
		clang-"${LLVM_VER}"-doc
		clang-format-"${LLVM_VER}"
		clang-tidy-"${LLVM_VER}"
		clang-tools-"${LLVM_VER}"
		cmake
		gcc
		gcovr
		gettext
		gnu-standards
		g++
		lcov
		libboost-all-dev
		libclang1-"${LLVM_VER}"
		libclang-"${LLVM_VER}"-dev
		libclang-common-"${LLVM_VER}"-dev
		libclang-rt-"${LLVM_VER}"-dev
		libc++abi-"${LLVM_VER}"-dev
		libc++-"${LLVM_VER}"-dev
		libfuzzer-"${LLVM_VER}"-dev
		libllvm"${LLVM_VER}"
		libllvm-"${LLVM_VER}"-ocaml-dev
		libssl-dev
		libunwind-"${LLVM_VER}"-dev
		lldb-"${LLVM_VER}"
		lld-"${LLVM_VER}"
		llvm-"${LLVM_VER}"
		llvm-"${LLVM_VER}"-dev
		llvm-"${LLVM_VER}"-runtime
		make
		pkg-config
		python3-clang-"${LLVM_VER}"
	)

	# wget -q https://apt.llvm.org/llvm.sh
	# chmod -v +x llvm.sh
	# ./llvm.sh 16 all

	echo Creating /etc/apt/sources.list.d/llvm.list
	tee -a /etc/apt/sources.list.d/llvm.list <<-EOF
		# deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm main
		# deb-src http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm main
		deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-"${LLVM_VER}" main
		deb-src http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-"${LLVM_VER}" main
	EOF

	#wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
	echo Running: curl -sS https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
	time curl -sS https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc || track_errors
	printf "\n"

	echo Running: sudo apt update
	time sudo apt update || track_errors
	printf "\n"

	echo Running: sudo apt install -y "${PACKAGES[@]}"
	time sudo apt install -y "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: sudo apt-mark manual "${PACKAGES[@]}"
	time sudo apt-mark manual "${PACKAGES[@]}" || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

main "${@}" |& tee "${HOME}"/layer-10.00-devcontainer-gcc_clang_llvm.log
