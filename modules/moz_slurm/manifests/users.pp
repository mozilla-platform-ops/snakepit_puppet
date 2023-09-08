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

  #   $relops = lookup('user_groups.relops', Array, undef, undef)
  # $relops.each |String $user| {
  #   User<| title == $user |> { groups +> ['wheel', 'bitbar', 'adm'] }
  # }


}
