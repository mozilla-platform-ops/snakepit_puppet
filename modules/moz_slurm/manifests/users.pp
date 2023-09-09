class moz_slurm::users {
  # currently used user ids across the cluster:
  #
  # 0
  # 1
  # 2
  # 3
  # 4
  # 5
  # 6
  # 7
  # 8
  # 9
  # 10
  # 13
  # 33
  # 34
  # 38
  # 39
  # 41
  # 100
  # 101
  # 102
  # 103
  # 104
  # 105
  # 106
  # 107
  # 108
  # 109
  # 110
  # 111
  # 112
  # 113
  # 114
  # 999
  # 1000
  # 1003
  # 1777
  # 1877
  # 65534

  # plan: human users start at id 2000

  # TODO: create slurm group while we are disabling 'slurm' module convergence

  group { 'slurm':
    ensure     => present,
    name       => $slurm::slurm_user_group,
    gid        => $slurm::slurm_group_gid,
    forcelocal => true,
    system     => true,
  }

  $base_users = lookup('all_users', Hash, undef, undef)

  # Additional users such as temporary access to loaner hosts
  $additional_users = lookup('additional_users', Hash, 'first', {})

  # Merge base and additional users
  $all_users = $base_users + $additional_users

  # rename to materialize users
  class { 'moz_slurm::all_users':
    all_users => $all_users,
  }

  $relops = lookup('user_groups.relops', Array, undef, undef)
  $relops.each |String $user| {
    User<| title == $user |> { groups +> ['slurm'] }
  }
}
