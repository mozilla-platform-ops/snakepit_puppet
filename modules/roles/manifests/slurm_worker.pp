class roles::slurm_worker {

    # TODO: manage users and ssh keys

    # munge is installed by slurm module
    #
    # class { 'munge':
    #   # the 'key' defines the security realm for a node, https://github.com/dun/munge/wiki/Man-7-munge
    #   munge_key_content => base64('decode', lookup('munge::munge_key_content'))
    # }

    include slurm

    # TODO: should moz_slurm's children include this?
    include moz_slurm
    include moz_slurm::packages
    include moz_slurm::worker::nfs
    # install spack
    include moz_slurm::spack
    # TODO: configure worker's env vars to use proxy
    # include moz_slurm::worker::proxy_env

    # next steps moved to roles::slurm_worker_post to save time when testing

}
