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

# TODO: replace with https://docs.chef.io/inspec/resources/etc_fstab/
# describe fstab do
#   it do
#     should have_entry(
#       device: "192.168.1.1:/snakepit",
#       mount_point: "/mnt/snakepit",
#       type: "nfs",
#       options: {
#         nosuid: true,
#         hard: true,
#         udp: true,
#         bg: true,
#         noatime: true
#       },
#       dump: 0,
#       pass: 0
#     )
#   end
# end

# /data
#   /ro
#     /shared (contents of mlchead/snakepit/shared/)
#   /rw
#     /group-GROUP (any groups you're in, contents of mlchead/snakepit/groups/GROUP)
#     /home (user dir, mlchead/snakepit/home/USER)
#     /pit (job dir, mlchead/snakepit/pits/ID)
#
# exports:
#   /snakepit/shared      192.168.0.0/16(ro,no_root_squash,no_subtree_check)
#   /moz_slurm/user_data  192.168.0.0/16(rw,no_root_squash,no_subtree_check)
#
# fstab:
#        options => 'nosuid,hard,udp,bg,noatime',

describe etc_fstab.where { mount_point == "/data/ro" } do
  its("device_name") { should cmp "192.168.1.1:/snakepit/shared" }
  its("file_system_type") { should cmp "nfs" }
  its("mount_options") { should eq [["nosuid", "hard", "udp", "bg", "noatime"]] }
  its("dump_options") { should cmp "0" }
  its("file_system_options") { should cmp "0" }
end

describe etc_fstab.where { mount_point == "/data/rw" } do
  its("device_name") { should cmp "192.168.1.1:/moz_slurm/user_data" }
  its("file_system_type") { should cmp "nfs" }
  its("mount_options") { should eq [["nosuid", "hard", "udp", "bg", "noatime"]] }
  its("dump_options") { should cmp "0" }
  its("file_system_options") { should cmp "0" }
end
