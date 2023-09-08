describe service("slurmd") do
  it { should be_installed }
  it { should be_enabled }

  # TODO: figure out why this is failing in kitchen and re-enable
  #
  # 26]: slurmd: error: Node configuration differs from hardware: CPUs=4:6(hw) Boar
  # 26]: error: Node configuration differs from hardware: CPUs=4:6(hw) Boards=1:1(h
  # 26]: CPU frequency setting not configured for this node
  # 26]: error: unable to mount freezer cgroup namespace: Operation not permitted
  # 26]: error: unable to create freezer cgroup namespace
  # 26]: error: Couldn't load specified plugin name for proctrack/cgroup: Plugin in
  # 26]: error: cannot create proctrack context for proctrack/cgroup
  # 26]: error: slurmd initialization failed
  #
  # it { should be_running }
end
