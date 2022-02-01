class moz_slurm {

  # include moz_slurm::spack_variables

  file {'/moz_slurm dir':
    ensure => 'directory',
    path   => '/moz_slurm',
    owner  => 'root',
    group  => 'root'
  }

  file {'/opt/moz_slurm dir':
    ensure => 'directory',
    path   => '/opt/moz_slurm',
    owner  => 'root',
    group  => 'root'
  }

  # create snakepit group, because we add the slurm to it
  group { 'snakepit group':
    ensure => 'present',
    name   => 'snakepit',
    gid    => 1777
  }

  # add slurm user to snakepit group
  User<|title == 'slurm'|> { groups => ['slurm', 'snakepit'] }

  # make bin dir
  file {'/opt/moz_slurm dir/bin':
    ensure => 'directory',
    path   => '/opt/moz_slurm',
    owner  => 'root',
    group  => 'root'
  }

  # place slurm monitoring script
  file { '/opt/moz_slurm/bin/monitor_slurm.sh':
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/moz_slurm/monitor_slurm.sh',
  }

}
