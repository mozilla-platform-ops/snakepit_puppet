class moz_slurm::worker::nfs {

  # install nfs client package
  package {
      'nfs-common':
          ensure => present;
  }

  ## configure mount points and fstab

  # create mount directory
  file { '/data':
    ensure => 'directory',
    path   => '/data',
    mode   => '0750',  # TODO: what should these be? also update README.md. is it important when it's just mounted over?
    owner  => 'root',
    group  => 'root'
  }

  # /data/ro

  # create mountpoint
  file { '/data/ro':
    ensure => 'directory',
    path   => '/data/ro',
    mode   => '0750',  # TODO: what should these be? also update README.md. is it important when it's just mounted over?
    owner  => 'slurm',
    group  => 'slurm'
  }

  # # configure fstab
  mount { '/data/ro':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/data_ro',
    fstype  => 'nfs',
    options => 'nosuid,hard,udp,bg,noatime',
    pass    => 0
  }

  # /data/rw

  # create mountpoint
  file { '/data/rw':
    ensure => 'directory',
    path   => '/data/rw',
    mode   => '0750',  # TODO: what should these be? also update README.md. is it important when it's just mounted over?
    owner  => 'slurm',
    group  => 'slurm'
  }

  # # configure fstab
  mount { '/data/rw':
    ensure  => 'mounted',  # just present so we can converge in puppet?
    atboot  => true,
    device  => '192.168.1.1:/data_rw',
    fstype  => 'nfs',
    options => 'nosuid,hard,udp,bg,noatime',
    pass    => 0
  }

}
