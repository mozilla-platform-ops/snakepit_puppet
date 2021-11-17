#!/usr/bin/env bash

set -e
set -x

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${SCRIPTPATH}"

docker build . -t slurmpit_test_container
docker run -it slurmpit_test_container
