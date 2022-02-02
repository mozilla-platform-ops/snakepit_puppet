class moz_slurm::worker::install_libcudnn {

  include apt

  # install libcudnn
  #   - steps from https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html
  #   its a 1gb file, so shouldn't commit in repo.
  #
  # steps:
  #   - store on aws s3 account (done once)
  #   - cache in nfs shared area on master (done in moz_slurm::head::place_cuda)
  #   - install via nfs mount (this class)
  #
  # notes:
  #   - the s3 cached file still doesn't contain all required files.
  #     - during apt installation, things are fetched from network :(
  #       - the whole point of caching the file. UGH.

  $cudnn_package_root = 'cudnn-local-repo-ubuntu1804'
  $cudnn_version = '8.3.2.44'
  $cuda_version = '11.5'
  # from `gpg --keyid-format 0xlong /var/cudnn-local-repo-ubuntu1804-8.3.2.44/7fa2af80.pub`
  $cudnn_repo_apt_key_fingerprint = 'AE09FE4BBD223A84B2CCFCE3F60F4B3D7FA2AF80'  # pragma: allowlist secret

  # install from nfs mount
  $cudnn_repo_package = "${cudnn_package_root}-${cudnn_version}"
  package { $cudnn_repo_package:
    ensure   => installed,
    provider => dpkg,
    source   => '/data/ro/data/relops_data/cudnn-local-repo-ubuntu1804-8.3.2.44_1.0-1_amd64.deb'
  }

  # sudo apt-key add /var/cudnn-local-repo-*/7fa2af80.pub
  apt::key { 'cudatools <cudatools@nvidia.com>':
    id     =>  $cudnn_repo_apt_key_fingerprint,
    source => "/var/cudnn-local-repo-ubuntu1804-${cudnn_version}/7fa2af80.pub",
    notify => Exec['apt_update']
  }

  # Install the runtime library.
  #   sudo apt-get install libcudnn8=8.x.x.x-1+cudaX.Y
  # Install the developer library.
  #   sudo apt-get install libcudnn8-dev=8.x.x.x-1+cudaX.Y
  # Install the code samples and the cuDNN library documentation.
  #   sudo apt-get install libcudnn8-samples=8.x.x.x-1+cudaX.Y
  package{ 'libcudnn8':
    ensure => "=${cudnn_version}-1+cuda${cuda_version}"
  }
  package { 'libcudnn8-dev':
    ensure => "=${cudnn_version}-1+${cuda_version}"
                      }
  package { 'libcudnn8-samples':
    ensure => "${cudnn_version}-1+${cuda_version}"
  }

}
