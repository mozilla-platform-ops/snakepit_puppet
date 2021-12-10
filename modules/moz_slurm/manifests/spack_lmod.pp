class moz_slurm::spack_lmod {

  # include moz_slurm::spack

  $spack_bin_path = lookup('moz_slurm::spack_bin_path')

  exec {'install lmod':
    command  => "${spack_bin_path} install lmod",
    provider => shell,
    user     => 'slurm',
    unless   => "${spack_bin_path} find lmod",
    timeout  => 3600,
  }

  file_line { 'add lmod env source to .bashrc':
    path => '/home/slurm/.bashrc',
    line => 'source $(spack location -i lmod)/lmod/lmod/init/bash',
  }

}
