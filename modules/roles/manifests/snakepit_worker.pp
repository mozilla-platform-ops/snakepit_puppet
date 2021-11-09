class roles::snakepit_worker {

    # include ::roles_profiles::profiles::relops_users
    # include ::roles_profiles::profiles::cia_users
    # include ::roles_profiles::profiles::sudo
    # include ::roles_profiles::profiles::bitbar_devicepool
    # include ::roles_profiles::profiles::remove_bootstrap_user

    class { 'munge':
      # the 'key' defines the security realm for a node, https://github.com/dun/munge/wiki/Man-7-munge
      munge_key_content => base64('decode', lookup('munge::munge_key_content'))
    }

}
