class moz_slurm::head::place_cuda {

  # place libcudnnn files on nfs share
  #
  # cuDNN v8.3.2 (January 10th, 2022), for CUDA 11.5
  # https://developer.nvidia.com/rdp/cudnn-download#a-collapse832-115
  file { 'cudnn-local-repo-ubuntu1804-8.3.2.44_1.0-1_amd64.deb':
    ensure => 'present',
    path   => '/data/ro/data/relops_data/cudnn-local-repo-ubuntu1804-8.3.2.44_1.0-1_amd64.deb',
    # file is requires acceptance of a license, get location from vault/hiera
    source => $moz_slurm::libcudnn_url,
  }

}
