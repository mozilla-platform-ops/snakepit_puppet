###
### spack is done in the post phase, so this won't work currently
###

# spack_bin_path = "/home/slurm/software/spack/bin/spack"

# describe command(spack_bin_path) do
#   it { should exist }
# end

# describe command("#{spack_bin_path} --version") do
#   its("exit_status") { should eq 0 }
# end

# # CircleCI sets CI and CIRCLECI=true
# in_circleci = ENV["CIRCLECI"]
# # TODO: figure out where to set this with kitchen. binstubs?
# in_kitchen = ENV["KITCHEN"]

# # don't run these in CI because we're not doing it in puppet any longer, too slow
# # - but will still be able to verify a host in prod (not sure how to invoke though)
# unless in_circleci || in_kitchen
#   describe command("#{spack_bin_path} find lmod") do
#     its("exit_status") { should eq 0 }
#   end

#   describe command("#{spack_bin_path} find singularity") do
#     its("exit_status") { should eq 0 }
#   end
# end
