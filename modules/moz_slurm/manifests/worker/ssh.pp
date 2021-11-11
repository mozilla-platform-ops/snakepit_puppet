class moz_slurm::worker::ssh {

  # root@mlchead's ssh key
  ssh_authorized_key { 'root@mlchead':
    user => 'root',
    type => 'ssh-rsa',
    key  => strip(template('snakepit/mlchead_root_ssh_pubkey.key')),
  }

}
