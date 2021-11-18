#!/usr/bin/env bash

set -e
set -x

container_name="slurmpit_container"

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${SCRIPTPATH}"

docker build . -t "$container_name"
docker run -it "$container_name"
