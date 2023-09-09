class moz_slurm::users {
  # currently used user ids across the cluster:
  #   nothing between 1999 and 60000
  #
  # plan:
  #   users:
  #     relops and releng: 2000
  #     translations: 2100
  #   groups:
  #     3000

  # create slurm group and user while we are disabling 'slurm' module convergence
  $slurm_user_name = 'slurm'
  $slurm_user_group = 'slurm'
  $slurm_user_uid = lookup('slurm::slurm_user_uid')
  $slurm_user_gid = lookup('slurm::slurm_group_gid')
  group { 'slurm':
    ensure     => present,
    name       => $slurm_user_group,
    gid        => $slurm_user_gid,
    forcelocal => true,
    system     => true,
  }
  user { 'slurm':
    ensure     => present,
    name       => $slurm_user_name,
    uid        => $slurm_user_uid,
    gid        => $slurm_user_gid,
    home       => "/home/${slurm_user_name}",
    shell      => '/bin/bash',
    managehome => true,
    forcelocal => true,
    system     => true,
  }

  group { 'admin':
    ensure     => present,
    name       => 'admin',
    gid        => 3000,
    forcelocal => true,
    system     => true,
  }

  $base_users = lookup('all_users', Hash, undef, undef)

  # Additional users such as temporary access to loaner hosts
  $additional_users = lookup('additional_users', Hash, 'first', {})

  # Merge base and additional users
  $all_users = $base_users + $additional_users

  # rename to materialize users
  class { 'users::all_users':
    all_users => $all_users,
  }

  $relops = lookup('user_groups.relops', Array, undef, undef)
  # TODO: how to put these users in sudoers group?
  realize(Users::Single_user[$relops])

  $translations = lookup('user_groups.translations', Array, undef, undef)
  realize(Users::Single_user[$translations])

  # add translations and translations users to groups
  $relops.each |String $user| {
    User<| title == $user |> { groups +> ['slurm', 'users', 'admin', 'sudo'] }
  }
  $translations.each |String $user| {
    User<| title == $user |> { groups +> ['slurm', 'users'] }
  }

  # place sudoers file
  #   in files dir in module
  file { '/etc/sudoers':
    ensure  => 'file',
    content => file("${module_name}/sudoers"),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }
}
