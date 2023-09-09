describe user("root") do
  it { should exist }
end

# TODO: check for slurm user and correct uid/gid
#       ... slurm group

describe user("aerickson") do
  it { should exist }
  its('groups') { should eq ["users", "sudo", "slurm", "admin"]}
end

describe user("epavlov") do
  it { should exist }
  its('groups') { should eq ['users', 'slurm']}
end

describe user("gtatum") do
  it { should exist }
  its('groups') { should eq ['users', 'slurm']}
end

describe file('/etc/sudoers') do
  # pragma: allowlist nextline secret
  its('content') { should match(%r{%admin ALL=\(ALL\) NOPASSWD: ALL}) }
  # pragma: allowlist nextline secret
  its('content') { should match(%r{epavlov  ALL=\(slurm\) NOPASSWD:ALL}) }
end
