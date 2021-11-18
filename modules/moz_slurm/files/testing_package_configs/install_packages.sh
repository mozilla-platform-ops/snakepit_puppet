#!/usr/bin/env bash

# idea: this script will be used to install packages on bare metal and in the containers
#       so that they can be kept in sync more easily.

set -e
set -x

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

aptget install \
  cuda-11-5=11.5.0-1 \
  cuda-cccl-11-5=11.5.62-1 \
  cuda-command-line-tools-11-5=11.5.0-1 \
  cuda-compiler-11-5=11.5.0-1 \
  cuda-cudart-11-5=11.5.50-1 \
  cuda-cudart-dev-11-5=11.5.50-1 \
  cuda-cuobjdump-11-5=11.5.50-1 \
  cuda-cupti-11-5=11.5.57-1 \
  cuda-cupti-dev-11-5=11.5.57-1 \
  cuda-cuxxfilt-11-5=11.5.50-1 \
  cuda-demo-suite-11-5=11.5.50-1 \
  cuda-documentation-11-5=11.5.50-1 \
  cuda-driver-dev-11-5=11.5.50-1 \
  cuda-drivers=495.29.05-1 \
  cuda-drivers-495=495.29.05-1 \
  cuda-gdb-11-5=11.5.50-1 \
  cuda-libraries-11-5=11.5.0-1 \
  cuda-libraries-dev-11-5=11.5.0-1 \
  cuda-memcheck-11-5=11.5.50-1 \
  cuda-nsight-11-5=11.5.50-1 \
  cuda-nsight-compute-11-5=11.5.0-1 \
  cuda-nsight-systems-11-5=11.5.0-1 \
  cuda-nvcc-11-5=11.5.50-1 \
  cuda-nvdisasm-11-5=11.5.50-1 \
  cuda-nvml-dev-11-5=11.5.50-1 \
  cuda-nvprof-11-5=11.5.50-1 \
  cuda-nvprune-11-5=11.5.50-1 \
  cuda-nvrtc-11-5=11.5.50-1 \
  cuda-nvrtc-dev-11-5=11.5.50-1 \
  cuda-nvtx-11-5=11.5.50-1 \
  cuda-nvvp-11-5=11.5.50-1 \
  cuda-runtime-11-5=11.5.0-1 \
  cuda-samples-11-5=11.5.56-1 \
  cuda-sanitizer-11-5=11.5.50-1 \
  cuda-toolkit-11-5=11.5.0-1 \
  cuda-toolkit-11-5-config-common=11.5.50-1 \
  cuda-toolkit-11-config-common=11.5.50-1 \
  cuda-toolkit-config-common=11.5.50-1 \
  cuda-tools-11-5=11.5.0-1 \
  cuda-visual-tools-11-5=11.5.0-1 \
  libnvidia-cfg1-495:amd64=495.44-0ubuntu0.18.04.1 \
  libnvidia-common-495=495.44-0ubuntu0.18.04.1 \
  libnvidia-compute-495:amd64=495.44-0ubuntu0.18.04.1 \
  libnvidia-decode-495:amd64=495.44-0ubuntu0.18.04.1 \
  libnvidia-encode-495:amd64=495.44-0ubuntu0.18.04.1 \
  libnvidia-extra-495:amd64=495.44-0ubuntu0.18.04.1 \
  libnvidia-fbc1-495:amd64=495.44-0ubuntu0.18.04.1 \
  libnvidia-gl-495:amd64=495.44-0ubuntu0.18.04.1 \
  nvidia-compute-utils-495=495.44-0ubuntu0.18.04.1 \
  nvidia-dkms-495=495.44-0ubuntu0.18.04.1 \
  nvidia-driver-495=495.44-0ubuntu0.18.04.1 \
  nvidia-kernel-common-495=495.44-0ubuntu0.18.04.1 \
  nvidia-kernel-source-495=495.44-0ubuntu0.18.04.1 \
  nvidia-modprobe=495.29.05-0ubuntu1 \
  nvidia-prime=0.8.16~0.18.04.1 \
  nvidia-settings=495.29.05-0ubuntu1 \
  nvidia-utils-495=495.44-0ubuntu0.18.04.1 \
  xserver-xorg-video-nvidia-495=495.44-0ubuntu0.18.04.1
