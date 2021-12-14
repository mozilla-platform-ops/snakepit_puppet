describe file("/mnt/snakepit") do
  it { should exist }
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by "snakepit" }
  it { should be_grouped_into "snakepit" }
end

# TODO: replace with https://docs.chef.io/inspec/resources/etc_fstab/
describe fstab do
  it do
    should have_entry(
      device: "192.168.1.1:/snakepit",
      mount_point: "/mnt/snakepit",
      type: "nfs",
      options: {
        nosuid: true,
        hard: true,
        udp: true,
        bg: true,
        noatime: true
      },
      dump: 0,
      pass: 0
    )
  end
end

# verify nfs-common package
describe package("nfs-common") do
  it { should be_installed }
end
