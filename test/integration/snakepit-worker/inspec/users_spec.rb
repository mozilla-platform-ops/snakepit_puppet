describe user("root") do
  it { should exist }
end

# check for slurm user and correct uid/gid, slurm group
describe user("slurm") do
  it { should exist }
  its('uid') { should eq 1877 }
  its('gid') { should eq 1877 }
  its('group') { should eq "slurm"}
  its('groups') { should eq ["slurm", "snakepit"]}
end

describe group('slurm') do
  it { should exist }
  its('gid') { should eq 1877 }
end

describe user("aerickson") do
  it { should exist }
  its('groups') { should eq ["users", "slurm", "admin"]}
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
