#

class moz_slurm::packages {

    # common (to head and workers) packages

    $pkgs_to_install = [ 'vim', 'iputils-ping', 'git', 'wget', 'tmux', 'screen', 'htop', 'nano', 'build-essential', 'make' ]
    package { $pkgs_to_install: ensure => 'installed' }

}
