class moz_slurm::worker::proxy_env {

  # configure slurm user's environment to use the proxy server

  # TODO: place /etc/apt/apt.conf.d/proxy.conf

  # TODO: place /etc/profile.d/proxy_env.sh

  # TODO: add lines below to /etc/environment
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
