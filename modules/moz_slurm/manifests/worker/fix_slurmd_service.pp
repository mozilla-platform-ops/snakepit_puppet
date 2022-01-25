class moz_slurm::worker::fix_slurmd_service {

  # the slurm distro provided service file (used by puppet-slurm)
  # looks at /etc/sysconfig vs /etc/default for options

  file_line { 'slurm service file options path fix':
    ensure => present,
    path   => '/etc/systemd/system/slurmd.service',
    line   => 'EnvironmentFile=-/etc/default/slurmd',
    match  => 'EnvironmentFile=-/etc/sysconfig/slurmd',
    notify => Service['slurmd'],
  }

}
