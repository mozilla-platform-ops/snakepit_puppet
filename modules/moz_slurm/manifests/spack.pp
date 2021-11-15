class moz_slurm::spack {

  # TODO: don't use this class in integration testing?
  #       - will take a very long time to compile everything

  # see https://www.palmetto.clemson.edu/palmetto/software/spack/
  # for an example setup

  $software_path = '/home/slurm/software'
  $spack_path = "${software_path}/spack"
  $spack_bin_path = "${spack_path}/bin/spack"

  # create software dir
  file { $software_path:
    ensure => directory,
    owner  => 'slurm',
    group  => 'slurm',
    mode   => '0750',
  }

  # clone repo
  vcsrepo { $spack_path:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/spack/spack.git',
    user     => 'slurm'
  }

  file_line { 'add spack env source to .bashrc':
    path => '/home/slurm/.bashrc',
    line => "source ${$spack_path}/share/spack/setup-env.sh",
  }

  exec {'install lmod':
    command  => "${spack_bin_path} install lmod",
    provider => shell,
    user     => 'slurm',
    unless   => "${spack_bin_path} find lmod",
  }

  file_line { 'add lmod env source to .bashrc':
    path => '/home/slurm/.bashrc',
    line => 'source $(spack location -i lmod)/lmod/lmod/init/bash',
  }

  # install singularity
  exec {'install singularity':
    command  => "${spack_bin_path} install singularity",
    provider => shell,
    user     => 'slurm',
    unless   => "${spack_bin_path} find singularity",
  }
}
