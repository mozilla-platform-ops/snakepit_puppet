describe "users" do
  describe user("root") do
    it { should exist }
  end
end

# TODO: check for slurm user and correct uid/gid
#       ... slurm group

describe "users" do
  describe user("aerickson") do
    it { should exist }
    its('groups') { should eq ["users", "sudo", "slurm", "admin"]}
  end

  describe user("epavlov") do
    it { should exist }
    its('groups') { should eq ['users', 'slurm', 'admin']}
  end

  describe user("gtatum") do
    it { should exist }
    its('groups') { should eq ['users', 'slurm']}
  end
end
