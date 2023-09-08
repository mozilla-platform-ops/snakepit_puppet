class moz_slurm::head::mysql_server {
  # TODO: manage ssh keys and human users

  # install mysql
  class { 'mysql::server':
    root_password           => lookup('mysql::root_password'),  # pragma: allowlist secret
    remove_default_accounts => true,
    restart                 => true,
    purge_conf_dir          => true,  # default config sets bind-address to localhost
    # override_options        => $override_options,  # set in hiera
  }
}
