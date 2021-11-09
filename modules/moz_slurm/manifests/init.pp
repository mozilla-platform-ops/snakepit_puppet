class moz_slurm (
  # thinking: could have multiple installs on a system?
  String $version = undef,
  String $install_root = '/opt',

  # user configuration
  $slurm_user_group       = 'slurm',
  $slurm_group_gid        = undef,
  $slurm_user             = 'slurm',
  $slurm_user_uid         = undef,
  $slurm_user_comment     = 'SLURM User',
  $slurm_user_home        = '/home/slurm',
  $slurm_user_managehome  = true,
  $slurm_user_shell       = '/sbin/nologin',
  $slurmd_user            = 'root',
  $slurmd_user_group      = 'root',
)
{
  file { "${install_root}/slurm-v${version}":
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root'
  }

  # TODO: compile

}






