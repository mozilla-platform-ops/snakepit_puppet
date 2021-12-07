# container nvidia driver sync solution

## steps

### optional: run a proxy

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

### 1. generate a new metadata installation recipe

cd creating_new_package_configs
./build_and_run.sh
# copy the output and paste it into ../testing_package_configs/install_packages.sh

### 2. test a new installation recipe

cd testing_package_configs
./build_and_run.sh
# things should complete without errors
# `nvidia-smi` should be present, but won't work yet

## TODOs

- create/store full BOMs also (datetime-stamped)
  - worst case scenario with install files, we can restore to base by removing all?
