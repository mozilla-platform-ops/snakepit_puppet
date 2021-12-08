class moz_slurm {

  # include moz_slurm::spack_variables

  file {'moz_slurm dir':
    ensure => 'directory',
    path   => '/opt/moz_slurm',
    owner  => 'root',
    group  => 'root'
  }

}
