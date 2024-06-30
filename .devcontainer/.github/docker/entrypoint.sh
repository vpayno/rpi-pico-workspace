#!/bin/sh

# https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions

# shellcheck disable=SC1091
# Setup the environment. Note: ${HOME} isn't available yet.
. "/root/.bashrc"
printf "\n"

# `$#` expands to the number of arguments and `$@` expands to the supplied `args`
printf "Starting container entrypoint.sh:\n"
printf "\targ count: %d\n" "$#"
printf "\targs: ["
printf " '%s'" "$@"
printf " ]\n"

"$@"
