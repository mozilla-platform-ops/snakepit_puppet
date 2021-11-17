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

    # install spack and lmod/singularity via spack
    # TODO: takes way too long... only run in prod (use hiera to set a key that only runs)?
    #       - https://vincent.bernat.ch/en/blog/2014-serverspec-test-infrastructure#advanced-use
    include moz_slurm::spack

}
