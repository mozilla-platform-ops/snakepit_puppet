plan roles::worker_converge(
  TargetSpec $hosts,
) {
  apply_prep([$hosts])

  apply($hosts) {
    include roles::snakepit_worker
    include roles::snakepit_worker_post
  }
}
