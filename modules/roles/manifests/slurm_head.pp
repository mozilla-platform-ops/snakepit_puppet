class roles::slurm_head {
  # TODO: manage ssh keys and human users

  include moz_slurm::head::mysql_server

  # munge installed by slurm module
  # test steps:
  #   https://github.com/dun/munge/blob/master/QUICKSTART in section 7.A.

  # slurm install (`include slurm`) moved to (disabled) post. it's too risky to
  # converge slurm due to version drift and infrequency of convergence/updates
  # to this repo.

  include moz_slurm
  include moz_slurm::users
  include moz_slurm::packages
  include moz_slurm::head::nfs

  # install spack
  include moz_slurm::spack

  # interesting slurmdbd options:
  #   https://gist.github.com/DaisukeMiyamoto/d1dac9483ff0971d5d9f34000311d312
  #   http://wiki.sc3.uis.edu.co/index.php/Slurm_Installation_on_Debian

  # test with slurmdbd -Dvvvv
}
