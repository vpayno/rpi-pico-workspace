#!/bin/bash
#
# .github/docker/layer-15.00-devcontainer-rust.sh
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
		clang-"${LLVM_VER}"
		clang-tidy-"${LLVM_VER}"
		clang-tools-"${LLVM_VER}"
		cmake
		g++
		gcovr
		lcov
		libllvm-"${LLVM_VER}"-ocaml-dev
		libllvm"${LLVM_VER}"
		libssl-dev
		lld-"${LLVM_VER}"
		llvm-"${LLVM_VER}"
		llvm-"${LLVM_VER}"-dev
		llvm-"${LLVM_VER}"-doc
		llvm-"${LLVM_VER}"-examples
		llvm-"${LLVM_VER}"-runtime
	)

	declare -a CRATES
	CRATES=(
		cargo-audit
		cargo-cache
		cargo-deps
		cargo-deps-list
		cargo-edit
		cargo-fix
		cargo-fuzz
		cargo-kcov
		cargo-llvm-cov
		cargo-tarpaulin
		clippy-sarif
		grcov
		sarif-fmt
		spellcheck
		strip-ansi-cli
		zellij
	)

	declare -a COMPONENTS
	COMPONENTS=(
		clippy
		llvm-tools
		rustfmt
	)

	echo Running: sudo apt update
	time sudo apt update || track_errors
	printf "\n"

	echo Running: sudo apt install -y "${PACKAGES[@]}"
	time sudo apt install -y "${PACKAGES[@]}" || track_errors
	printf "\n"

	echo Running: sudo apt-mark manual "${PACKAGES[@]}"
	time sudo apt-mark manual "${PACKAGES[@]}" || track_errors
	printf "\n"

	tee /etc/profile.d/rust.sh <<-EOF
		#
		# /etc/profile.d/rust.sh
		#

		export RUSTUP_HOME="/usr/local/rustup"
		export RUSTPATH="/usr/local/cargo"
		export CARGO_HOME="\${RUSTPATH}"
		export RUSTBIN="\${RUSTPATH}/bin"
		export PATH="\${RUSTBIN}:\${PATH}"
		export CARGO_REGISTRIES_CRATES_IO_PROTOCOL="sparse"
	EOF

	echo Adding source /etc/profile.d/rust.sh to ~/.bashrc and /etc/skel/.bashrc
	echo '. /etc/profile.d/rust.sh' | tee -a "${HOME}/.bashrc" | tee -a /etc/skel/.bashrc
	printf "\n"

	echo Running: source /etc/profile.d/rust.sh
	# shellcheck disable=SC1091
	source /etc/profile.d/rust.sh || track_errors
	printf "\n"

	printf "PATH=%s\n" "${PATH}"
	printf "RUSTUP_HOME=%s\n" "${RUSTUP_HOME}"
	printf "RUSTPATH=%s\n" "${RUSTPATH}"
	printf "CARGO_HOME=%s\n" "${CARGO_HOME}"
	printf "RUSTBIN=%s\n" "${RUSTBIN}"
	printf "CARGO_REGISTRIES_CRATES_IO_PROTOCOL=%s\n" "${CARGO_REGISTRIES_CRATES_IO_PROTOCOL}"
	printf "\n"

	echo Running: mkdir -pv "${RUSTUP_HOME}"
	mkdir -pv "${RUSTUP_HOME}"
	printf "\n"

	echo Running: mkdir -pv "${RUSTUP_HOME}"
	mkdir -pv "${RUSTUP_HOME}"
	printf "\n"

	echo Running: ln -sv "${CARGO_HOME}" "${HOME}/.cargo"
	ln -sv "${CARGO_HOME}" "${HOME}/.cargo"
	printf "\n"

	echo Running: ln -sv "${RUSTUP_HOME}" "${HOME}/.rustup"
	ln -sv "${RUSTUP_HOME}" "${HOME}/.rustup"
	printf "\n"

	echo Running: ln -sv "${CARGO_HOME}" "/etc/skel/.cargo"
	ln -sv "${CARGO_HOME}" "/etc/skel/.cargo"
	printf "\n"

	echo Running: ln -sv "${RUSTUP_HOME}" "/etc/skel/.rustup"
	ln -sv "${RUSTUP_HOME}" "/etc/skel/.rustup"
	printf "\n"

	echo Running: curl https://sh.rustup.rs -sSf \| bash -s -- -y
	time curl https://sh.rustup.rs -sSf | bash -s -- -y || track_errors
	printf "\n"

	echo Running: rustup install stable
	time rustup install stable || track_errors
	printf "\n"

	echo Running: rustup default stable
	time rustup default stable || track_errors
	printf "\n"

	echo Running: rustc --version
	rustc --version || track_errors
	printf "\n"

	echo Running: cargo install sccache
	time cargo install sccache || track_errors
	printf "\n"

	# this has to be added to the environment after sccache is installed
	export RUSTC_WRAPPER="sccache"
	echo export RUSTC_WRAPPER="sccache" | tee -a /etc/profile.d/rust.sh
	printf "\n"

	echo Running: sccache --start-server
	time sccache --start-server
	printf "\n"

	for component in "${COMPONENTS[@]}"; do
		echo Running: rustup component add "${component}"
		time rustup component add "${component}" || track_errors
		printf "\n"
	done

	echo Running: cargo install "${CRATES[@]}"
	time cargo install "${CRATES[@]}" || track_errors
	printf "\n"

	printf "Installed Rust components:\n"
	echo Running: rustup component list
	time rustup component list
	printf "\n"

	printf "Installed Crates:\n"
	echo Running: cargo install --list
	time cargo install --list
	printf "\n"

	printf "Show Rust Configuration:\n"
	echo Running: rustup show
	time rustup show
	printf "\n"

	printf "Show Rust sccache Info:\n"
	echo Running: sccache --show-stats
	sccache --show-stats
	printf "\n"

	printf "Show Rust Cache Info:\n"
	echo Running: cargo cache --info
	cargo cache --info
	printf "\n"

	echo Running: du -shc "${HOME}"/.cargo/registry/ /usr/local/cargo/registry/ "${HOME}"/.cache/sccache/
	time du -shc "${HOME}"/.cargo/registry/ /usr/local/cargo/registry/ "${HOME}"/.cache/sccache/
	printf "\n"

	echo Running: rm -rf "${HOME}"/.cargo/registry/ /usr/local/cargo/registry/ "${HOME}"/.cache/sccache/
	time rm -rf "${HOME}"/.cargo/registry/ /usr/local/cargo/registry/ "${HOME}"/.cache/sccache/
	printf "\n"

	echo Running: chgrp -R adm "${RUSTUP_HOME}" "${CARGO_HOME}"
	chgrp -R adm "${RUSTUP_HOME}" "${CARGO_HOME}" || track_errors
	printf "\n"

	echo Running: setfacl -RPdm g:adm:w "${RUSTUP_HOME}" "${CARGO_HOME}"
	setfacl -RPdm g:adm:w "${RUSTUP_HOME}" "${CARGO_HOME}" || track_errors
	printf "\n"

	layer_end "${0}" "$@"

	echo Running: return "${retval}"
	return "${retval}"
}

time main "${@}" |& tee "${HOME}"/layer-15.00-devcontainer-rust.log
