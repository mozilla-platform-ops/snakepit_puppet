# snakepit_puppet

puppet code for managing the Slurm deployment on Mozilla's Snakepit cluster

## TODOs

- puppet
  - create production secrets.yaml file
  - set slurm uid/gids that work in prod
  - configure NFS mount points
  - future: manage users on the hosts
- bolt
  - figure out how to apply roles and test (used for initial convergence, and worker post convergence)
    - won't do interpolated hiera data... why bother then...?
      - just use puppet provisioner from ronin-puppet.
- package configuration code
  - Test updating instances... will running the install script just work?
    - i.e. start with 11-4 and upgrade to 11-5
      - will conflict?
      - maybe make an uninstall script that removes the exact ones installed previously...
        - then can use newer version's install script.

## provisioner notes

I had hoped to use bolt to do the masterless convergence, but it doesn't provide debug output like `puppet apply` and `--noop` usage isn't obvious.

TODO: test to see if this is still broken, now that hiera lookup is fixed.

## test-kitchen testing

test-kitchen automates testing roles and integrates serverspec tests for verification.

```bash
# initial setup
brew install puppet-bolt  # or equivalent
bundle install
bolt module install  # install 3rd party modules to .modules

# converge head and worker roles
bundle exec kitchen converge

# run integration tests
bundle exec kitchen verify
```

## vagrant testing

vagrant testing is lower level than test-kitchen and allows more realistic testing of the bolt provisioning and convergence process.

```bash
vagrant up
vagrant ssh

# once in the vagrant node
cd /vagrant

# puppet_apply:
# uses main branch
sudo /vagrant/provisioner/converge_worker.sh
# override for testing
sudo PUPPET_REPO=https://github.com/aerickson/snakepit_puppet.git PUPPET_BRANCH=work_1 /vagrant/provisioner/converge_worker.sh

# bolt: NOT WORKING (due to hiera interpolation not being done)
# run one of the following
# to converge a worker node
sudo bolt plan run roles::worker_converge hosts=localhost --verbose --log-level debug
# to converge the host as a head node
sudo bolt plan run roles::head_converge hosts=localhost --verbose --log-level debug
```

## keeping bare metal and containers in sync

Part of the challenge of using NVIDIA cards and CUDA in a container is that the versions of the software on the bare metal and the container need to be in sync (https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/concepts.html#background).

NVIDIA has a solution (NVIDIA Container Toolkit) that allows the versions to not match exactly, but it requires newer NVIDIA GPUs (Kepler and newer, https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#platform-requirements). Snakepit's GPUs are from a previous genenration and we can't use this solution.

The NVIDIA-recommended solution for our older cards is to install the `cuda` or `cuda-11-5` metapackage (https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) and hope things work. These metapackages only loosely specify the version to use and float to the latest published packages. This causes issues when trying to keep hosts in sync (if they're installed or created at different points in time).

```bash
$ apt-cache show cuda-11-5
...
Depends: cuda-runtime-11-5 (>= 11.5.0), cuda-toolkit-11-5 (>= 11.5.0), cuda-demo-suite-11-5 (>= 11.5.50)
...
```

To remedy this problem, we find what packages the metapackage installs. Once the packages have been identified, we craft an install script that installs all of the constituent packages (those including cuda and nvidia in the name, the full dependency list is very large). The install script is then used to install the required packages on the bare metal hosts and any containers.

### creating and testing package configurations

#### 0. run a proxy (optional)

These steps install lots of packages. Caching will speed things up dramatically.

Any caching web proxy on port 8123 will work. I like polipo (in homebrew).

```bash
#!/usr/bin/env bash

set -e

mkdir -p /tmp/cache/polipo
polipo -c polipo.conf
```

```bash
# polipo.conf contents
diskCacheRoot=/tmp/cache/polipo
logLevel=4
```

#### 1. create a new installation script

```bash
rake pkg_config_create

# inspect the output in
#   modules/moz_slurm/create_package_configuration/boms/ and paste it into
#   modules/moz_slurm//testing_package_configs/install_packages.sh
```

#### 2. test a new installation script

```bash
rake pkg_config_test

# things should complete without errors and
#   `nvidia-smi` should be present (but won't work yet).
```

## misc

### links

- puppet module used for slurm
  - <https://github.com/treydock/puppet-slurm>

### how to generate new munge keys

in the test-kitchen head node, run `/usr/sbin/create-munge-key` and overwrite the existing key and then base64 it.

in a `python` interpreter:

```python
import base64
with open("/etc/munge/munge.key", "rb") as image_file:
    encoded_string = base64.b64encode(image_file.read()); print(encoded_string)
```
