# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

define users::single_user (
  String $user                 = $title,
  Integer $uid                 = $uid,
  String $shell                = '/bin/bash',
  Array $ssh_keys              = [],
  Array $groups                = [],
  Optional[String] $password   = undef,  # pragma: allowlist secret
  Optional[String] $salt       = undef,
  Optional[String] $iterations = undef,
) {
  # include resources common to ALL users
  # include users::global

  $group = $facts['os']['name'] ? {
    # 'Darwin' => 'staff',
    default  => 'users',
  }

  $home = $facts['os']['name'] ? {
    default  => "/home/${user}"
  }

  case $facts['os']['family'] {
    'Debian': {
      # If values for password, salt and iteration are passed, then set the user with a password
      if $password and $salt and $iterations {
        user { $user:
          gid        => $group,
          shell      => $shell,
          home       => $home,
          groups     => $groups,
          comment    => $user,
          password   => $password,  # pragma: allowlist secret
          salt       => $salt,
          iterations => $iterations,
        }
      } else {
        user { $user:
          uid     => $uid,
          gid     => $group,
          shell   => $shell,
          home    => $home,
          groups  => $groups,
          comment => $user,
        }
      }
    }
    default: {
      fail("${module_name} does not support ${facts['os']['family']}")
    }
  }

  # Create home dir
  users::home_dir { $home:
    user     => $user,
    group    => $group,
    ssh_keys => $ssh_keys,
  }
}
