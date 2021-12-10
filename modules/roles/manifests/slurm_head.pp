class roles::slurm_head {

    # TODO: manage ssh keys and human users

    include moz_slurm::packages

    # install mysql
    class { 'mysql::server':
      root_password           => lookup('mysql::root_password'), #'strongpassword',
      remove_default_accounts => true,
      restart                 => true,
      purge_conf_dir          => true,  # default config sets bind-address to localhost
      # override_options        => $override_options,  # set in hiera
    }

    # munge installed by below, test steps: https://github.com/dun/munge/blob/master/QUICKSTART

    include slurm

    # interesting slurmdbd options:
    #   https://gist.github.com/DaisukeMiyamoto/d1dac9483ff0971d5d9f34000311d312
    #   http://wiki.sc3.uis.edu.co/index.php/Slurm_Installation_on_Debian

    # test with slurmdbd -Dvvvv

    # TODO: configure NFS packages/mounts

}
