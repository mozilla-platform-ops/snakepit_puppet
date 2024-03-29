class roles::slurm_head_post {
  # idea behind this class:
  #   the things in this file take too long to run for CI,
  #   so split up convergence.

  # it's too risky to converge slurm due to version drift and infrequency
  # of convergence/updates to this repo.
  #include slurm

  # TODO: should moz_slurm's children include this?
  include moz_slurm

  # install lmod and spack
  include moz_slurm::spack_lmod
  include moz_slurm::spack_singularity

  # place cuda libs in nfs share
  include moz_slurm::head::place_cuda
}
