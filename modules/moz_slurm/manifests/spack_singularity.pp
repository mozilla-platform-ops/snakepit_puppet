class moz_slurm::spack_singularity {

  require moz_slurm::spack
  require moz_slurm::spack_lmod

  # variables just in double quoted strings won't get resolved
  $spack_bin_path = lookup('moz_slurm::spack_bin_path')

  # install singularity
  exec {'install singularity':
    command  => "bash -c '${spack_bin_path} install singularity'",
    provider => shell,
    user     => 'slurm',
    unless   => "${spack_bin_path} find singularity",
    timeout  => 3600,
  }

}
