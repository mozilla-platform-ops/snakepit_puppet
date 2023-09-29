class roles::slurm_worker {
  # TODO: manage users and ssh keys

  # slurm install (`include slurm`) moved to (disabled) post. it's too risky to
  # converge slurm due to version drift and infrequency of convergence/updates
  # to this repo.

  # TODO: should moz_slurm's children include this?
  include moz_slurm
  include moz_slurm::users
  include moz_slurm::packages
  include moz_slurm::worker::disable_automated_upgrades

  # TODO: configure worker's env vars to use proxy
  # include moz_slurm::worker::proxy_env

  # next steps moved to roles::slurm_worker_post to save time when testing
}
