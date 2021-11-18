class moz_slurm::spack_lmod {

  require moz_slurm::spack

  # include moz_slurm::spack_variables

  exec {'install lmod':
    command  => "${spack::spack_bin_path} install lmod",
    provider => shell,
    user     => 'slurm',
    unless   => "${spacks::spack_bin_path} find lmod",
    timeout  => 3600,
  }

  file_line { 'add lmod env source to .bashrc':
    path => '/home/slurm/.bashrc',
    line => 'source $(spack location -i lmod)/lmod/lmod/init/bash',
  }

}
