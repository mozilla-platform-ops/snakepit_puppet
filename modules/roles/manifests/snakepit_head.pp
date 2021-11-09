class roles::snakepit_head {

    # include ::roles_profiles::profiles::relops_users
    # include ::roles_profiles::profiles::cia_users
    # include ::roles_profiles::profiles::sudo
    # include ::roles_profiles::profiles::bitbar_devicepool
    # include ::roles_profiles::profiles::remove_bootstrap_user

    class { 'munge':
      munge_key_source  => 'puppet:///modules/roles/munge.key',
    }

}
