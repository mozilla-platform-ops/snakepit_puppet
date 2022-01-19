class moz_slurm {

  # include moz_slurm::spack_variables

  file {'/moz_slurm dir':
    ensure => 'directory',
    path   => '/moz_slurm',
    owner  => 'slurm',
    group  => 'slurm'
  }

  file {'/opt/moz_slurm dir':
    ensure => 'directory',
    path   => '/opt/moz_slurm',
    owner  => 'slurm',
    group  => 'slurm'
  }

  # add slurm user to snakepit group
  User<|title == 'slurm'|> { groups => ['slurm', 'snakepit'] }

}
