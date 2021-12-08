spack_bin_path = "/home/slurm/software/spack/bin/spack"

describe command(spack_bin_path) do
  it { should exist }
end

describe command("#{spack_bin_path} --version") do
  its("exit_status") { should eq 0 }
end

# TODO: need to disable in kitchen also...
# CircleCI sets CI and CIRCLECI=true
in_circleci = ENV["CIRCLECI"]

# don't run these in CI because we're not doing it in puppet any longer, too slow
# - but will still be able to verify a host in prod (not sure how to invoke though)
unless in_circleci
  describe command("#{spack_bin_path} find lmod") do
    its("exit_status") { should eq 0 }
  end

  describe command("#{spack_bin_path} find singularity") do
    its("exit_status") { should eq 0 }
  end
end
