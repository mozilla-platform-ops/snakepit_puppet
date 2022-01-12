class moz_slurm::worker::disable_automated_upgrades {

  # disable auto-upgrades by placing file with desired options
  #   /etc/apt/apt.conf.d/20auto-upgrades
  file {'apt autoupgrades file':
    ensure => 'present',
    source => 'puppet:///modules/moz_slurm/20auto-upgrades',
    path   => '/etc/apt/apt.conf.d/20auto-upgrades',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

}
