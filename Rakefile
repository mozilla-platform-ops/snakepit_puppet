# task default: [:create_package_configuration]

# test-kitchen

desc "verify worker"
task :kitchen_verify_worker do |t|
  sh "KITCHEN=1 bundle exec kitchen verify worker"
end

desc "verify head"
task :kitchen_verify_head do |t|
  sh "KITCHEN=1 bundle exec kitchen verify head"
end

# cuda package config stuff

desc "Create a package configuration"
task :pkg_config_create do |t|
  sh "./modules/moz_slurm/files/creating_new_package_configs/build_and_run.sh"
end

desc "Create a distribution package"
task :pkg_config_test do |t|
  sh "./modules/moz_slurm/files/testing_package_configs/build_and_run.sh"
end
