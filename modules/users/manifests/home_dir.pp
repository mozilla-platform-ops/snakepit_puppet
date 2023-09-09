# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

define users::home_dir (
  String $user,
  String $group,
  String $home    = $title,
  Array $ssh_keys = [],
) {
  case $facts['os']['family'] {
    'Debian': {
      # Create user home directory and populate it with skeleton files and users custom files
      file { $home:
        ensure  => 'directory',
        mode    => 'g-w,o-rwx',
        owner   => $user,
        group   => $group,
        require => User[$user],
      }

      users::user_ssh_config { $user:
        group    => $group,
        home     => $home,
        ssh_keys => $ssh_keys,
        require  => File[$home],
      }
    }
    default: {
      fail("${module_name} does not support ${facts['os']['family']}")
    }
  }
}
