  describe user("root") do
    it { should exist }
  end

  describe user("slurm") do
    it { should exist }
    its("uid") { should eq 1877 }
    its("gid") { should eq 1877 }
    its("home") { should eq "/home/slurm" }
    its("shell") { should eq "/bin/bash" }
  end

  # TODO: check for slurm user and correct uid/gid
  #       ... slurm group
