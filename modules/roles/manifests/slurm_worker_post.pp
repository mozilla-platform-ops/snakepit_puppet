class roles::slurm_worker_post {
  # idea behind this class:
  #   the things in this file take too long to run for CI,
  #   so split up convergence.

  # TODO: rename this to full and include slurm_worker
  # - rename to phase 1 and complete (includes phase 2)?

  # it's too risky to converge slurm due to version drift and infrequency
  # of convergence/updates to this repo.
  #include slurm

  # TODO: should moz_slurm's children include this?
  include moz_slurm

  include moz_slurm::worker::install_cuda
  include moz_slurm::worker::fix_slurmd_service

  # ensure that cuda packages are present before doing slurm installation
  Class['moz_slurm::worker::install_cuda'] ~> Class['slurm'] ~> Class['moz_slurm::worker::nfs']
  # ensure slurmd service exists before running fix
  # Service['slurmd'] -> Class['moz_slurm::worker::fix_slurmd_service']

  # these are now installed on the head as /home/slurm is nfs mounted
  #
  # install lmod and spack
  # include moz_slurm::spack_lmod
  # include moz_slurm::spack_singularity

  include moz_slurm::worker::install_libcudnn
}
