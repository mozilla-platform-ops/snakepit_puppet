class roles::slurm_worker {

    # TODO: manage users and ssh keys

    include slurm

    # TODO: should moz_slurm's children include this?
    include moz_slurm
    include moz_slurm::packages
    include moz_slurm::worker::nfs
    include moz_slurm::worker::disable_automated_upgrades
    # manage packages (including cuda/nvidia-driver)
    include moz_slurm::worker::install_cuda

    # ensure that cuda packages are present before doing slurm installation
    Class['moz_slurm'] ~> Class['slurm']

    # TODO: configure worker's env vars to use proxy
    # include moz_slurm::worker::proxy_env

    # next steps moved to roles::slurm_worker_post to save time when testing

}
