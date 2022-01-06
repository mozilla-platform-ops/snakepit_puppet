#!/usr/bin/env bash

set -e

source /home/slurm/software/spack/share/spack/setup-env.sh
source "$(spack location -i lmod)/lmod/lmod/init/bash"

spack install singularity
