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
aptget install software-properties-common wget

# install pkg repos
# from https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=18.04&target_type=deb_network
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600

# use curl to install key - it respect proxy settings
# apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
curl -sSL \
  'https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub' \
  | sudo apt-key add -
# apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
curl -sSL \
  'https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub' \
  | sudo apt-key add -
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
aptget update

# --allow-downgrades may be required
aptget install \
  "cuda-cccl-11-5=11.5.62-1" \
  "cuda-command-line-tools-11-5=11.5.1-1" \
  "cuda-compiler-11-5=11.5.1-1" \
  "cuda-cudart-11-5=11.5.117-1" \
  "cuda-cudart-dev-11-5=11.5.117-1" \
  "cuda-cuobjdump-11-5=11.5.119-1" \
  "cuda-cupti-11-5=11.5.114-1" \
  "cuda-cupti-dev-11-5=11.5.114-1" \
  "cuda-cuxxfilt-11-5=11.5.119-1" \
  "cuda-demo-suite-11-5=11.5.50-1" \
  "cuda-documentation-11-5=11.5.114-1" \
  "cuda-driver-dev-11-5=11.5.117-1" \
  "cuda-drivers=495.29.05-1" \
  "cuda-drivers-495=495.29.05-1" \
  "cuda-gdb-11-5=11.5.114-1" \
  "cuda-libraries-11-5=11.5.1-1" \
  "cuda-libraries-dev-11-5=11.5.1-1" \
  "cuda-memcheck-11-5=11.5.114-1" \
  "cuda-nsight-11-5=11.5.114-1" \
  "cuda-nsight-compute-11-5=11.5.1-1" \
  "cuda-nsight-systems-11-5=11.5.1-1" \
  "cuda-nvcc-11-5=11.5.119-1" \
  "cuda-nvdisasm-11-5=11.5.119-1" \
  "cuda-nvml-dev-11-5=11.5.50-1" \
  "cuda-nvprof-11-5=11.5.114-1" \
  "cuda-nvprune-11-5=11.5.119-1" \
  "cuda-nvrtc-11-5=11.5.119-1" \
  "cuda-nvrtc-dev-11-5=11.5.119-1" \
  "cuda-nvtx-11-5=11.5.114-1" \
  "cuda-nvvp-11-5=11.5.114-1" \
  "cuda-runtime-11-5=11.5.1-1" \
  "cuda-samples-11-5=11.5.56-1" \
  "cuda-sanitizer-11-5=11.5.114-1" \
  "cuda-toolkit-11-5=11.5.1-1" \
  "cuda-toolkit-11-5-config-common=11.5.117-1" \
  "cuda-toolkit-11-config-common=11.5.117-1" \
  "cuda-toolkit-config-common=11.5.117-1" \
  "cuda-tools-11-5=11.5.1-1" \
  "cuda-visual-tools-11-5=11.5.1-1" \
  "gds-tools-11-5=1.1.1.25-1" \
  "libcublas-11-5=11.7.4.6-1" \
  "libcublas-dev-11-5=11.7.4.6-1" \
  "libcufft-11-5=10.6.0.107-1" \
  "libcufft-dev-11-5=10.6.0.107-1" \
  "libcufile-11-5=1.1.1.25-1" \
  "libcufile-dev-11-5=1.1.1.25-1" \
  "libcurand-11-5=10.2.7.107-1" \
  "libcurand-dev-11-5=10.2.7.107-1" \
  "libcusolver-11-5=11.3.2.107-1" \
  "libcusolver-dev-11-5=11.3.2.107-1" \
  "libcusparse-11-5=11.7.0.107-1" \
  "libcusparse-dev-11-5=11.7.0.107-1" \
  "libnpp-11-5=11.5.1.107-1" \
  "libnpp-dev-11-5=11.5.1.107-1" \
  "libnvidia-cfg1-495:amd64=495.29.05-0ubuntu1" \
  "libnvidia-common-495=495.29.05-0ubuntu1" \
  "libnvidia-compute-495:amd64=495.29.05-0ubuntu1" \
  "libnvidia-decode-495:amd64=495.29.05-0ubuntu1" \
  "libnvidia-encode-495:amd64=495.29.05-0ubuntu1" \
  "libnvidia-extra-495:amd64=495.29.05-0ubuntu1" \
  "libnvidia-fbc1-495:amd64=495.29.05-0ubuntu1" \
  "libnvidia-gl-495:amd64=495.29.05-0ubuntu1" \
  "libnvjpeg-11-5=11.5.4.107-1" \
  "libnvjpeg-dev-11-5=11.5.4.107-1" \
  "libxnvctrl0:amd64=495.29.05-0ubuntu1" \
  "nsight-compute-2021.3.1=2021.3.1.4-1" \
  "nsight-systems-2021.3.3=2021.3.3.2-b99c4d6" \
  "nvidia-compute-utils-495=495.29.05-0ubuntu1" \
  "nvidia-dkms-495=495.29.05-0ubuntu1" \
  "nvidia-driver-495=495.29.05-0ubuntu1" \
  "nvidia-kernel-common-495=495.29.05-0ubuntu1" \
  "nvidia-kernel-source-495=495.29.05-0ubuntu1" \
  "nvidia-modprobe=495.29.05-0ubuntu1" \
  "nvidia-settings=495.29.05-0ubuntu1" \
  "nvidia-utils-495=495.29.05-0ubuntu1" \
  "xserver-xorg-video-nvidia-495=495.29.05-0ubuntu1"

# record that the installation finished successfully
touch /etc/moz_slurm_cuda_packages_installed
