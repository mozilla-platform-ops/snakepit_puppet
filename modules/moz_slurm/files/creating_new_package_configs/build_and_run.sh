#!/usr/bin/env bash

set -e
set -x

# NOTES:
#   "$@" is passed to the build command

container_name="slurmpit_container"

if [ -z "$container_name" ]; then
  echo "please specify a container name"
  exit 1
fi

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${SCRIPTPATH}"

# cache http requests if proxy server is running
# see if polipo is up
status=0
nc -v -z localhost 8123 || status=$?

if [ "$status" == 0 ] ; then
	# polipo is running
	echo "* using proxy"
	echo ""

	proxy_host=host.docker.internal
	export http_proxy="http://localhost:8123"
	export https_proxy="http://localhost:8123"

	docker build --build-arg http_proxy=http://$proxy_host:8123 \
		--build-arg https_proxy=http://$proxy_host:8123 \
		"$@" \
		-t "$container_name" .
else
	# polipo is not running
	echo "* not using proxy"
	echo ""

	docker build "$@" -t "$container_name" .
fi

# set -x
# docker run "$container_name" python3 /tmp/generate_install_command.py
# { set +x; } 2>/dev/null  # set +x without output

# echo ""
# echo "SUCESS. run \`docker run -it '$container_name'\` for futher debugging"

set -x
echo ""
output_dir="boms/$(date +%Y%m%d%H%M%S)"
mkdir -p "$output_dir"
# instantiates image as container, so we can copy from it
docker rm -f dummy || true
docker create -it --name dummy "$container_name" bash
docker start dummy
docker exec "dummy" python3 /tmp/generate_install_command.py
docker cp "dummy":/tmp/output "$output_dir"
# docker cp "dummy":/tmp/output/final_bom.txt "$output_dir"
# docker cp "dummy:/tmp/packages-in*" "$output_dir"
docker rm -f dummy
