package_names = ["vim", "iputils-ping", "git", "wget", "tmux", "screen", "htop", "nano", "build-essential", "make"]

package_names.each do |item|
  describe package(item) do
    it { should be_installed }
  end
end
