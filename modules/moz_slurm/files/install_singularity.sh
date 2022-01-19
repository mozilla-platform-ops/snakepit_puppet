#!/usr/bin/env bash

set -e

# TODO: don't hardcode this
. /data/sw/spack/share/spack/setup-env.sh
# shellcheck source=/dev/null
. "$(spack location -i lmod)/lmod/lmod/init/bash"

# debugging
# env
# spack load go
# env
# go version

# installs suid... non-root can't use
#spack install singularity

# disable suid
spack install singularity -suid
