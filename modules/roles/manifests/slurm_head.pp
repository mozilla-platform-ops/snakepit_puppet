class roles::slurm_head {

    # TODO: manage ssh keys and human users

    # install mysql
    class { 'mysql::server':
      root_password           => lookup('mysql::root_password'),  # pragma: allowlist secret
      remove_default_accounts => true,
      restart                 => true,
      purge_conf_dir          => true,  # default config sets bind-address to localhost
      # override_options        => $override_options,  # set in hiera
    }

    # munge installed by slurm module
    # test steps:
    #   https://github.com/dun/munge/blob/master/QUICKSTART in section 7.A.

    include slurm

    include moz_slurm
    include moz_slurm::packages
    include moz_slurm::head::nfs

    # install spack
    include moz_slurm::spack

    # interesting slurmdbd options:
    #   https://gist.github.com/DaisukeMiyamoto/d1dac9483ff0971d5d9f34000311d312
    #   http://wiki.sc3.uis.edu.co/index.php/Slurm_Installation_on_Debian

    # test with slurmdbd -Dvvvv

}
