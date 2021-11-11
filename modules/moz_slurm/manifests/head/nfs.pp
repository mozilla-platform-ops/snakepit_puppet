class moz_slurm::head::nfs {

  # install NFS server
  package {
      'nfs-kernel-server':
          ensure => present;
  }

  service { 'nfs-server':
    ensure  => 'running',
    enable  => true,
    require => Package['nfs-kernel-server'],
  }

  # TODO: configure /etc/exports
  # file { '/etc/exports':
  #   mode    => '0644',
  #   owner   => 'root',
  #   group   => 'root',
  #   content => template('snakepit/etc_exports'),
  #   notify  => Service['nfs-server'],
  # }

  # TODO: configure number of NFS daemon threads
  # root@mlchead:/etc/default# cat nfs-kernel-server
  # Number of servers to start up
  # RPCNFSDCOUNT=32

  # TODO: configure more snakepit app dirs?

  # TODO: add relops users, add relops users to sudoers

  # TODO: configure nfsd
  # 32 on mlchead, set in /etc/defaults/nfs-kernel-server
  # RPCNFSDCOUNT=8

}
