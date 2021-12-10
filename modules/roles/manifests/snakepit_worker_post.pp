class roles::snakepit_worker_post {

    # idea behind this class:
    #   bolt will run post-convergence to do the heavy lifting
    #     e.g. bolt apply modules/roles/manifests/snakepit_worker_post.pp --targets workers

    # TODO: rename this to full and include snakepit_worker
    # - rename to phase 1 and complete (includes phase 2)?

    # TODO: should moz_slurm's children include this?
    include moz_slurm

    # install lmod and spack
    include moz_slurm::spack_lmod
    include moz_slurm::spack_singularity

    # manage packages (including cuda/nvidia-driver)
    include moz_slurm::worker::install_cuda

}
