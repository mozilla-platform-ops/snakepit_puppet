plan roles::head_converge(
  TargetSpec $hosts,
) {
  apply_prep([$hosts])

  apply($hosts) {
    include roles::slurm_head
  }
}
