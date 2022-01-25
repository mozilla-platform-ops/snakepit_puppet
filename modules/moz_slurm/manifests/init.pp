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

  # add slurm user to snakepit group
  User<|title == 'slurm'|> { groups => ['slurm', 'snakepit'] }

}
