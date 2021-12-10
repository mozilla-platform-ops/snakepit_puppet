class roles::snakepit_worker {

    # TODO: manage users and ssh keys

    # TODO: should moz_slurm's children include this?
    include moz_slurm
    include moz_slurm::packages

    class { 'munge':
      # the 'key' defines the security realm for a node, https://github.com/dun/munge/wiki/Man-7-munge
      munge_key_content => base64('decode', lookup('munge::munge_key_content'))
    }

    include slurm

    # TODO: configure nfs packages/mounts
    #       - evgeny says: like /data from snakepit scheduler

    # install spack
    include moz_slurm::spack

    # steps below moved to roles::snakepit_worker_post to be run by bolt post-convergence
    #
    # install lmod and spack
    # include moz_slurm::spack_lmod
    # include moz_slurm::spack_singularity
    #
    # manage packages (including cuda/nvidia-driver)
    # include moz_slurm::worker::install_cuda

}
