class roles::snakepit_worker {

    # TODO: manage users and ssh keys

    include moz_slurm::packages

    class { 'munge':
      # the 'key' defines the security realm for a node, https://github.com/dun/munge/wiki/Man-7-munge
      munge_key_content => base64('decode', lookup('munge::munge_key_content'))
    }

    include slurm

    # TODO: manage packages (including cude/nvidia-driver)
    # TODO: configure nfs packages/mounts

}
