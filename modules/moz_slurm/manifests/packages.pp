#

class moz_slurm::packages {

    # common (to head and workers) packages

    # make is installed by slurm and covered by build-essential below
    $pkgs_to_install = [ 'vim', 'iputils-ping', 'git', 'wget', 'tmux',
        'screen', 'htop', 'nano', 'build-essential', 'unzip' ]
    package { $pkgs_to_install: ensure => 'installed' }

}
