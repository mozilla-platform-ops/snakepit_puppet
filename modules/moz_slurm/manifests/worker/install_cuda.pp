class moz_slurm::worker::install_cuda {

  # if packages are missing
  # - call the installation script in files/test...

  $installation_script_path = '/opt/moz_slurm/install_cuda_packages.sh'
  $indicator_file_path = '/etc/moz_slurm_cuda_packages_installed'

  file {'installation script':
    ensure => 'present',
    source => 'puppet:///modules/moz_slurm/testing_package_configs/install_packages.sh',
    path   => "${installation_script_path}}",
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  exec {'install cuda packages':
    command  => $installation_script_path,
    provider => shell,
    user     => 'root',
    unless   => "ls ${indicator_file_path}",
    # 60 minute timeout
    timeout  => 3600,
  }

  file {'cuda packages installation indicator':
    ensure => 'present',
    path   => $indicator_file_path,
    mode   => '0644',
    owner  => 'root',
    group  => 'root'
  }

}
