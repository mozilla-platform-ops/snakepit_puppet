class roles::snakepit_worker {

    # TODO: manage users and ssh keys

    include moz_slurm::packages

    class { 'munge':
      # the 'key' defines the security realm for a node, https://github.com/dun/munge/wiki/Man-7-munge
      munge_key_content => base64('decode', lookup('munge::munge_key_content'))
    }

    include slurm

    # TODO: configure nfs packages/mounts

    # TODO: manage packages (including cuda/nvidia-driver)
    #       - figure out how to pull out? shell script or bolt (task)?

    # install spack
    include moz_slurm::spack

    # install lmod and spack
    # disabled for now, manually run on worker nodes for now. maybe use hiera value to control later?
    # include moz_slurm::spack_lmod
    # include moz_slurm::spack_singularity
    # TODO: figure out how to call the two above modules from bolt as a post-convergence step

}
