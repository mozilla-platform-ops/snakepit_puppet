class roles::snakepit_worker {

    # TODO: manage users and ssh keys

    include moz_slurm::packages

    class { 'munge':
      # the 'key' defines the security realm for a node, https://github.com/dun/munge/wiki/Man-7-munge
      munge_key_content => base64('decode', lookup('munge::munge_key_content'))
    }

    include slurm

    # TODO: configure nfs packages/mounts

    # TODO: should moz_slurm's children include this?
    include moz_slurm

    # install spack
    include moz_slurm::spack

    # install lmod and spack
    # disabled for now (takes super long)
    # - manually run on worker nodes for now. maybe use hiera value to control later?
    # TODO: write bolt plan that runs above as a post-convergence step
    # include moz_slurm::spack_lmod
    # include moz_slurm::spack_singularity

    # manage packages (including cuda/nvidia-driver)
    # TODO: move this out of initial convergence? see above
    include moz_slurm::worker::install_cuda

}
