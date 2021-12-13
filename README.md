# snakepit_puppet

puppet code for managing the Slurm deployment on Mozilla's Snakepit cluster

## TODOs

- puppet
  - create production secrets.yaml file
  - set slurm uid/gids that work in prod
  - configure NFS mount points
  - worker: set environment for proxy
    - https://github.com/mozilla/snakepit/pull/186/files
  - future: manage users on the hosts
  - future: proxy installation & configuration
- package configuration code
  - Test updating instances... will running the install script just work?
    - i.e. start with 11-4 and upgrade to 11-5
      - will conflict?
      - maybe make an uninstall script that removes the exact ones installed previously...
        - then can use newer version's install script.

## notes

### nfs mounts

Snakpit (the scheduler) only gives jobs access to their jobs directory, user directory, and group directory.

Slurm doesn't do any access control. If the slurm unix user can write to a directory, every job will be able to write to it.

```bash
#  server paths to client paths
/snakepit/shared/data: /data/ro
/moz_slurm/user_data: /data/rw
```

### provisioners

I had hoped to use bolt to do the masterless convergence, but it doesn't provide debug output like `puppet apply` and `--noop` usage isn't obvious.

## testing

test-kitchen is the best place to start. vagrant is easier for rapid iteration and for testing the provisioner script.

### vagrant testing

vagrant testing is lower level than test-kitchen and allows more realistic testing of the provisioning and convergence process.

```bash
vagrant up
# ssh into the 'head' or 'worker' instance
vagrant ssh worker

# once in the vagrant node
cd /vagrant

# puppet_apply convergence
#
# uses main branch
sudo /vagrant/provisioner/converge_worker.sh
sudo /vagrant/provisioner/converge_head.sh
# override for testing
sudo PUPPET_REPO=https://github.com/aerickson/snakepit_puppet.git PUPPET_BRANCH=work_1 /vagrant/provisioner/converge_worker.sh

# bolt convergence (alternative method)
#
# run one of the following
# to converge a worker node
sudo bolt plan run roles::worker_converge hosts=localhost --verbose --log-level debug
# to converge the host as a head node
sudo bolt plan run roles::head_converge hosts=localhost --verbose --log-level debug
```

### test-kitchen testing

test-kitchen automates the testing of roles and integrates inspec tests for verification.

test-kitchen is used for testing in CI, so the test-kitchen worker configuration does a partial converge for speed (see modules/roles/manifests/slurm_worker_post.pp).

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

Full BOMs (`dpkg --list` output) of the before and after state are captured also.

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
#   modules/moz_slurm/testing_package_configs/install_packages.sh
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
