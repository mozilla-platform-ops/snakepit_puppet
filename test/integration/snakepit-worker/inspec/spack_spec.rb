spack_bin_path = "/home/slurm/software/spack/bin/spack"

describe command(spack_bin_path) do
  it { should exist }
end

describe command("#{spack_bin_path} --version") do
  its("exit_status") { should eq 0 }
end

in_circleci = ENV["CIRCLECI"]

describe command("#{spack_bin_path} find lmod"), if: in_circleci do
  its("exit_status") { should eq 0 }
end

describe command("#{spack_bin_path} find singularity"), if: in_circleci do
  its("exit_status") { should eq 0 }
end
