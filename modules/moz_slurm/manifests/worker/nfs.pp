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
    mode   => '0750',
    owner  => 'root',
    group  => 'slurm'
  }

  # /data/ro

  # create mountpoint
  file { '/data/ro':
    ensure => 'directory',
    path   => '/data/ro',
    mode   => '0555',
    # snakepit doesn't exist on test infra, but is real owner in prod
    # owner  => 'snakepit',
    # group  => 'snakepit'
  }

  # # configure fstab
  mount { '/data/ro':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/snakepit/shared',
    fstype  => 'nfs',
    # udp forces v3, which locking seems broken on (at least in spack)
    options => 'nosuid,hard,bg,noatime',
    pass    => 0
  }

  # /data/rw

  # create mountpoint
  file { '/data/rw':
    ensure => 'directory',
    path   => '/data/rw',
    mode   => '0750',
    owner  => 'slurm',
    group  => 'slurm'
  }

  # configure fstab
  mount { '/data/rw':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/moz_slurm/user_data',
    fstype  => 'nfs',
    options => 'nosuid,hard,bg,noatime',
    pass    => 0
  }

  # mount /home/slurm
  mount { '/home/slurm':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/home/slurm',
    fstype  => 'nfs',
    options => 'nosuid,hard,bg,noatime',
    pass    => 0
  }

  # mount /snakepit/home -> /data/home
  mount { '/data/home':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/snakepit/home',
    fstype  => 'nfs',
    options => 'nosuid,hard,bg,noatime',
    pass    => 0
  }

}
