describe service("munge") do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service("slurmctld") do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service("slurmdbd") do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service("mysql") do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service("slurmrestd") do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
