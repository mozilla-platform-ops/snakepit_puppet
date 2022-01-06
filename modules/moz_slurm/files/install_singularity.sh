#!/usr/bin/env bash

set -e

. /home/slurm/software/spack/share/spack/setup-env.sh
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
