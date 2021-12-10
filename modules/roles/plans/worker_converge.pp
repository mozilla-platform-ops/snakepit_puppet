plan roles::worker_converge(
  TargetSpec $hosts,
) {
  apply_prep([$hosts])

  apply($hosts) {
    include roles::slurm_worker
    include roles::slurm_worker_post
  }
}
