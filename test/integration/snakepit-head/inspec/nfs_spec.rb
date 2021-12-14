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
  it { should be_mode 644 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  it { should contain "/snakepit       192.168.0.0/16(rw,no_root_squash,no_subtree_check)" }
end

# nfs testing on docker doesn't work (modules aren't loaded in host)
#  detect if we're on docker by inspecting PID 1's cgroup
def proc_1_cgroup
  file("/proc/1/cgroup").content
end

def is_docker
  if proc_1_cgroup.include?("docker")
    true
  else
    false
  end
end

# verify serivce is exporting them
describe command("exportfs"), if: !is_docker do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain "/snakepit     	192.168.0.0/16" }
end
