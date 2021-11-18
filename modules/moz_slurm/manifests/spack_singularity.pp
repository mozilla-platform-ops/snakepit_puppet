class moz_slurm::spack_singularity {

  require moz_slurm::spack
  require moz_slurm::spack_lmod

  # include moz_slurm::spack_variables

  # install singularity
  exec {'install singularity':
    command  => "${spack::spack_bin_path} install singularity",
    provider => shell,
    user     => 'slurm',
    unless   => "${spack::spack_bin_path} find singularity",
    timeout  => 3600,
  }

}
