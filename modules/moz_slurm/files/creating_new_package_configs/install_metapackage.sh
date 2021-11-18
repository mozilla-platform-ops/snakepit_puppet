#!/usr/bin/env bash

# idea: this script will be used to install packages on bare metal and in the containers
#       so that they can be kept in sync more easily.

set -e
# set -x

# functions

aptget() {
    DEBIAN_FRONTEND=noninteractive apt-get -yq "$@"
}

print_header () {
    printf "\n>>>>>>>> %s <<<<<<<<\n\n" "$1"
}

# install deps
aptget update
aptget install software-properties-common

# install pkg repos
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list
aptget update

# install packages
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#package-manager-metas
# - how to make sure this is deterministic... pin to exact versions in meta package?

# how to gather list of packages in metapackage
# 1. `apt-cache depends PKG` recursively
#     - https://askubuntu.com/questions/132872/how-can-i-determine-why-apt-get-will-install-a-package
# 2. run dpkg --list before and after installation of the metapackage

aptget install cuda-11-5  # just for bom generations
