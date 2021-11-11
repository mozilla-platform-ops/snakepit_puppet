# snakepit-puppet

puppet code for managing the Slurm deployment on Mozilla's Snakepit cluster

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
