# verify package present
describe package("nfs-kernel-server") do
  it { should be_installed }
end

# TODO: configure threads
# root@mlchead:/etc/default# cat nfs-kernel-server
# # Number of servers to start up
# RPCNFSDCOUNT=32

# verify exports
describe file("/etc/exports") do
  it { should exist }
  # it { should be_mode 644 }
  its("mode") { should cmp "0644" }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  its("content") { should match "^/snakepit/shared/data" }
  its("content") { should match "^/moz_slurm/user_data" }
  # it { should contain  }
end

# nfs testing on docker doesn't work (modules aren't loaded in host)
#  - related? `exportfs: /moz_slurm/user_data does not support NFS export`
#
# detect if we're on docker by inspecting PID 1's cgroup
def is_docker
  if File.exist?("/.dockerenv")
    true
  else
    false
  end
end

# verify serivce is exporting them
if is_docker
  describe command("exportfs") do
    its(:exit_status) { should eq 0 }
    its("stdout") { should match "/snakepit/shared/data" }
    its("stdout") { should match "/moz_slurm/user_data" }
  end
end
