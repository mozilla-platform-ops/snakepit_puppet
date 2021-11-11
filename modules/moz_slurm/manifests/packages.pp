#

class moz_slurm::packages {

    # common (to head and workers) packages

    $pkgs_to_install = [ 'vim', 'iputils-ping' ]
    package { $pkgs_to_install: ensure => 'installed' }

}
