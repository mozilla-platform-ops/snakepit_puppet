class moz_slurm::worker::install_libcudnn {

  # install libcudnn
  #   its a 1gb file, so shouldn't commit in repo.
  #
  # steps:
  #   - store on aws s3 account
  #   - cache in nfs shared area on master
  #   - install via nfs mount

  # placement on nfs share done in moz_slurm::head::place_cuda

  # install from nfs mount
  package { 'cudnn-local-repo-ubuntu1804-8.3.2.44':
    ensure   => present,
    provider => dpkg,
    source   => '/data/ro/data/relops_data/cudnn-local-repo-ubuntu1804-8.3.2.44_1.0-1_amd64.deb'
  }

}
