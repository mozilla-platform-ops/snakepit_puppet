describe "users" do
  describe user("root") do
    it { should exist }
  end
end

# TODO: check for slurm user and correct uid/gid
#       ... slurm group
