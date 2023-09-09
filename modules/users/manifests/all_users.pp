class users::all_users (
  Hash $all_users,
) {
  # Iterate over the $all_users hash and create virtual resources for all users
  # which can then be realized later in profile based on group definitions
  $all_users.each | String $user, Array $ssh_keys | {
    @users::single_user { $user:
      ssh_keys => $ssh_keys,
    }
  }
}
