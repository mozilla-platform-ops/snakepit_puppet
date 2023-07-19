class moz_slurm::spack_lmod {

  require moz_slurm::spack

  # variables just in double quoted strings won't get resolved
  $spack_bin_path = lookup('moz_slurm::spack_bin_path')

  exec {'install lmod':
    # need bash -c to load spack and lmod in .bashrc
    command  => "bash -c '${spack_bin_path} install lmod'",
    provider => shell,
    user     => 'slurm',
    unless   => "${spack_bin_path} find lmod",
    timeout  => 3600,
  }

  file_line { 'add lmod env source to .bashrc':
    path => '/home/slurm/.bashrc',
    # -L to ignore locks
    line => 'source $(spack -L location -i lmod)/lmod/lmod/init/bash',
  }

}
