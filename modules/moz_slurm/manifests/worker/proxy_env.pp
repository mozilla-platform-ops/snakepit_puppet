class moz_slurm::worker::proxy_env {

  # configure slurm user's environment to use the proxy server

  # snakepit legacy locations for setting this
  # TODO: clean out (manually) apt.conf, snakepit nodes have it set there
  # TODO: cleanup /etc/environment?

  # place /etc/apt/apt.conf.d/proxy.conf
  # TODO: enable?
  #
  # file { '/etc/apt/apt.conf.d/proxy.conf':
  #   mode   => '0644',
  #   owner  => 'root',
  #   group  => 'root',
  #   source => 'puppet:///modules/moz_slurm/worker_proxy_env/proxy_apt.conf',
  # }

  # place /etc/profile.d/proxy_env.sh
  # TODO: enable?
  #
  # file { '/etc/profile.d/proxy_env.sh':
  #   mode   => '0644',
  #   owner  => 'root',
  #   group  => 'root',
  #   source => 'puppet:///modules/moz_slurm/worker_proxy_env/proxy_env.sh',
  # }

  #

  # TODO: add lines below to /etc/environment
  # - is this needed if profile.d is set also?
  # /etc/environment doesn't do any variable interpolation (can't do HTTP_PROXY=$http_proxy)

  # echo 'http_proxy="http://192.168.1.1:3128/"' >> /etc/environment
  # echo 'https_proxy="http://192.168.1.1:3128/"' >> /etc/environment
  # echo 'ftp_proxy="http://192.168.1.1:3128/"' >> /etc/environment
  # echo 'no_proxy="localhost,127.0.0.1,::1,.mlc,192.168.1.1,10.2.224.243"' >> /etc/environment

  # echo 'HTTP_PROXY="http://192.168.1.1:3128/"' >> /etc/environment
  # echo 'HTTPS_PROXY="http://192.168.1.1:3128/"' >> /etc/environment
  # echo 'FTP_PROXY="http://192.168.1.1:3128/"' >> /etc/environment
  # echo 'NO_PROXY="localhost,127.0.0.1,::1,.mlc,192.168.1.1,10.2.224.243"' >> /etc/environment

}
