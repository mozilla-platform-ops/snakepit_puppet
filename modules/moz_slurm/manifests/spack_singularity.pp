class moz_slurm::spack_singularity {

  require moz_slurm::spack
  require moz_slurm::spack_lmod

  $installation_script_path = '/opt/moz_slurm/install_singularity.sh'
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
    command  => "bash -c '${installation_script_path}'",
    provider => shell,  # uses posix by default
    user     => 'slurm',
    cwd      => '/home/slurm',
    unless   => "${spack_bin_path} find singularity",
    timeout  => 3600,
  }

  # why does this fail? why???
  # - works fine on cli with sh

  # add spack load singularity to .bashrc
  file_line { 'add spack load singularity':
    path => '/home/slurm/.bashrc',
    # -L to ignore locks
    # do not use full path, want to use shell function
    line => 'spack -L load singularity',
  }

}
