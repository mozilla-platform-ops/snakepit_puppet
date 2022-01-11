class moz_slurm::spack {

  # TODO: don't use this class in integration testing?
  #       - will take a very long time to compile everything

  # see https://www.palmetto.clemson.edu/palmetto/software/spack/
  # for an example setup

  $spack_path = lookup('moz_slurm::spack_path')

  # create software dir
  file { lookup('moz_slurm::software_path'):
    ensure => directory,
    owner  => 'slurm',
    group  => 'slurm',
    mode   => '0750',
  }

  # clone repo
  vcsrepo { lookup('moz_slurm::spack_path'):
    ensure   => present,
    provider => git,
    source   => 'https://github.com/spack/spack.git',
    user     => 'slurm'
  }

  # takes a long time to load...
  # use tips in https://github.com/spack/spack/issues/3318?
  file_line { 'add spack env source to .bashrc':
    path => '/home/slurm/.bashrc',
    line => "source ${spack_path}/share/spack/setup-env.sh",
  }

  # TODO: define a set of modules all users get
  #       https://lmod.readthedocs.io/en/latest/070_standard_modules.html

  # TODO: make loading module easier? currently need fully hashed name...
  #       - like 'module load singularity-3.8.3-gcc-7.5.0-pyi4mc6'
  #       https://github.com/spack/spack/discussions/13775
  #       https://spack.readthedocs.io/en/latest/config_yaml.html

  # for docs: how to use spack in scripts:
  #   https://spack.readthedocs.io/en/latest/module_file_support.html#modules

}
