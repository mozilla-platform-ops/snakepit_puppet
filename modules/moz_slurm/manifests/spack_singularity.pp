class moz_slurm::spack_singularity {

  require moz_slurm::spack
  require moz_slurm::spack_lmod

  $installation_script_path = '/tmp/install_singularity.sh'
  # variables just in double quoted strings won't get resolved
  $spack_bin_path = lookup('moz_slurm::spack_bin_path')

  # place singularity installer
  file {'singularity installation script':
    ensure => 'present',
    source => 'puppet:///modules/moz_slurm/install_singularity.sh',
    path   => $installation_script_path,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  # install singularity
  exec {'install singularity':
    command  => "bash -c '/tmp/install_singularity.sh'",
    provider => shell,  # uses posix by default
    user     => 'slurm',
    cwd      => '/home/slurm',
    unless   => "${spack_bin_path} find singularity",
    timeout  => 3600,
  }

}
