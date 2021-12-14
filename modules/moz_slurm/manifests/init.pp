class moz_slurm {

  # include moz_slurm::spack_variables

  file {'moz_slurm dir':
    ensure => 'directory',
    path   => '/moz_slurm',
    owner  => 'slurm',
    group  => 'slurm'
  }

}
