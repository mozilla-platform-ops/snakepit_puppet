spack_bin_path = "/home/slurm/software/spack/bin/spack"

describe command(spack_bin_path) do
  it { should exist }
end

describe command("#{spack_bin_path} --version") do
  its("exit_status") { should eq 0 }
end

describe command("#{spack_bin_path} find lmod") do
  its("exit_status") { should eq 0 }
end

describe command("#{spack_bin_path} find singularity") do
  its("exit_status") { should eq 0 }
end
