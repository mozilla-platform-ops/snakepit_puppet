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
    ensure  => 'directory',
    path    => '/data/ro',
    mode    => '0555',
    # snakepit doesn't exist on test infra, but is real owner in prod
    # owner  => 'snakepit',
    # group  => 'snakepit'
    require => File['/data'],
  }

  # # configure fstab
  mount { '/data/ro':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/snakepit/shared',
    fstype  => 'nfs',
    # udp forces v3, which locking seems broken on (at least in spack)
    options => 'nosuid,hard,bg,noatime',
    pass    => 0,
    require => File['/data/ro'],
  }

  # /data/rw

  # create mountpoint
  file { '/data/rw':
    ensure  => 'directory',
    path    => '/data/rw',
    mode    => '0750',
    owner   => 'slurm',
    group   => 'slurm',
    require => File['/data'],
  }

  # configure fstab
  mount { '/data/rw':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/data/rw',
    fstype  => 'nfs',
    options => 'nosuid,hard,bg,noatime',
    pass    => 0,
    require => File['/data/rw'],
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

  # create mountpoint for /data/home
  file { '/data/home':
    ensure  => 'directory',
    path    => '/data/home',
    mode    => '0775',
    owner   => 'snakepit',
    group   => 'snakepit',
    require => File['/data'],
  }

  # mount /snakepit/home -> /data/home
  mount { '/data/home':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/snakepit/home',
    fstype  => 'nfs',
    options => 'nosuid,hard,bg,noatime',
    pass    => 0,
    require => File['/data/home'],
  }

  # create software dir (/data/sw)
  file { lookup('moz_slurm::software_path'):
    ensure => directory,
    owner  => 'slurm',
    group  => 'slurm',
    mode   => '0750',
  }

  # mount /data/sw
  mount { '/data/sw':
    ensure  => 'mounted',
    atboot  => true,
    device  => '192.168.1.1:/data/sw',
    fstype  => 'nfs',
    options => 'nosuid,hard,bg,noatime',
    pass    => 0,
    require => File['/data'],
  }

}
