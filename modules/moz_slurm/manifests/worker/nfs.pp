class moz_slurm::worker::nfs {

  # install nfs client package
  package {
      'nfs-common':
          ensure => present;
  }

  # TODO: configure mount points and fstab

  # create mountpoint
  # file { '/mnt/snakepit':
  #   ensure => 'directory',
  #   path   => '/mnt/snakepit',
  #   mode   => '0750',  # TODO: what should these be? also update README.md. is it important when it's just mounted over?
  #   owner  => 'snakepit',
  #   group  => 'snakepit'
  # }

  # # configure fstab
  # mount { '/mnt/snakepit':
  #   ensure  => 'mounted',
  #   atboot  => true,
  #   device  => '192.168.1.1:/snakepit',
  #   fstype  => 'nfs',
  #   options => 'nosuid,hard,udp,bg,noatime',
  #   pass    => 0
  # }

}
