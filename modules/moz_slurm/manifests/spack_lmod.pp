class moz_slurm::spack_lmod {

  # include moz_slurm::spack

  exec {'install lmod':
    command  => "%{lookup('moz_slurm::spack_bin_path')} install lmod",
    provider => shell,
    user     => 'slurm',
    unless   => "%{lookup('moz_slurm::spack_bin_path')} find lmod",
    timeout  => 3600,
  }

  file_line { 'add lmod env source to .bashrc':
    path => '/home/slurm/.bashrc',
    line => 'source $(spack location -i lmod)/lmod/lmod/init/bash',
  }

}
