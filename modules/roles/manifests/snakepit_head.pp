class roles::snakepit_head {

    # include ::roles_profiles::profiles::relops_users
    # include ::roles_profiles::profiles::cia_users
    # include ::roles_profiles::profiles::sudo
    # include ::roles_profiles::profiles::bitbar_devicepool
    # include ::roles_profiles::profiles::remove_bootstrap_user


    #
    # moz_slurm route
    #

    # class { 'munge':
    #   # the 'key' defines the security realm for a node, https://github.com/dun/munge/wiki/Man-7-munge
    #   munge_key_content => base64('decode', lookup('munge::munge_key_content'))
    # }

    # class { 'moz_slurm':
    #   slurm_version => '21.08'
    # }

    #
    # treydock/slurm route
    #

    # TODO: manage ssh keys and human users

    # TODO: pull out, add more packages per evgeny's spec
    package { 'vim':
      ensure => installed,
    }

    # install mysql
    class { 'mysql::server':
      root_password           => lookup('mysql::root_password'), #'strongpassword',
      remove_default_accounts => true,
      restart                 => true,
      purge_conf_dir          => true,  # default config sets bind-address to localhost
      # override_options        => $override_options,  # set in hiera
    }

    include slurm

    # interesting slurmdbd options:
    #   https://gist.github.com/DaisukeMiyamoto/d1dac9483ff0971d5d9f34000311d312

    # test with slurmdbd -Dvvvv

}
