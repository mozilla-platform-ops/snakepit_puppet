# verify nfs-common package
describe package("nfs-common") do
  it { should be_installed }
end

describe file("/data") do
  it { should exist }
  it { should be_directory }
  its("mode") { should cmp "00750" }
  its("owner") { should eq "root" }
  its("group") { should eq "slurm" }
end

describe etc_fstab.where { mount_point == "/data/ro" } do
  its("device_name") { should cmp "192.168.1.1:/snakepit/shared" }
  its("file_system_type") { should cmp "nfs" }
  its("mount_options") { should eq [["nosuid", "hard", "udp", "bg", "noatime"]] }
  its("dump_options") { should cmp "0" }
  its("file_system_options") { should cmp "0" }
end

describe etc_fstab.where { mount_point == "/data/rw" } do
  its("device_name") { should cmp "192.168.1.1:/data/rw" }
  its("file_system_type") { should cmp "nfs" }
  its("mount_options") { should eq [["nosuid", "hard", "udp", "bg", "noatime"]] }
  its("dump_options") { should cmp "0" }
  its("file_system_options") { should cmp "0" }
end
