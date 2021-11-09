class roles::snakepit_worker {

    # include ::roles_profiles::profiles::relops_users
    # include ::roles_profiles::profiles::cia_users
    # include ::roles_profiles::profiles::sudo
    # include ::roles_profiles::profiles::bitbar_devicepool
    # include ::roles_profiles::profiles::remove_bootstrap_user

}
