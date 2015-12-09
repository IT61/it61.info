Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # sync the app folder
  if (/cygwin|mswin|mingw|bccwin/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder "./", "/app/", type: "nfs"
  else
    config.vm.synced_folder "./", "/app/", type: "rsync"
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
  config.vm.provision :shell, path: 'bootstrap_app.sh', privileged: false
end
