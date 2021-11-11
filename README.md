# snakepit-puppet

puppet code for managing the Slurm deployment on Mozilla's Snakepit cluster

## TODOs

- set uid/gids that work in prod

## testing locally

```bash
# initial setup
brew install puppet-bolt  # or equivalent
bundle install
bolt module install  # install 3rd party modules to .modules

# converge
kitchen converge

# run integration tests
kitchen verify
```

## misc


### links

- puppet module used for slurm
  - https://github.com/treydock/puppet-slurm

### how to generate new munge keys

in the test-kitchen head node, run `/usr/sbin/create-munge-key` and overwrite the existing key and then base64 it.

in a `python` interpreter:

```python
import base64
with open("/etc/munge/munge.key", "rb") as image_file:
    encoded_string = base64.b64encode(image_file.read()); print(encoded_string)
```
