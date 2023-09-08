class roles::slurm_worker_post {
  # idea behind this class:
  #   the things in this file take too long to run for CI,
  #   so split up convergence.

  # TODO: rename this to full and include slurm_worker
  # - rename to phase 1 and complete (includes phase 2)?

  # TODO: should moz_slurm's children include this?
  include moz_slurm

  # these are now installed on the head as /home/slurm is nfs mounted
  #
  # install lmod and spack
  # include moz_slurm::spack_lmod
  # include moz_slurm::spack_singularity

  include moz_slurm::worker::install_libcudnn
}
