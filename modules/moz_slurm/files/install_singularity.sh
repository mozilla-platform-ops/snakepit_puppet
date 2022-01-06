#!/usr/bin/env bash

set -e

. /home/slurm/software/spack/share/spack/setup-env.sh
. "$(spack location -i lmod)/lmod/lmod/init/bash"

env

spack load go

go --version

env

spack install singularity
