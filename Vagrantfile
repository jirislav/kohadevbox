# -*- mode: ruby -*-
# vi: set ft=ruby :
DIGITAL_OCEAN_TOKEN="PASTE YOUR API TOKEN HERE"
DIGITAL_OCEAN_LOGIN="SET THIS UP TO YOUR DIGITALOCEAN LOGIN"
DIGITAL_OCEAN_HOSTNAME="HOSTNAME AT DNS OR DROPLET PUBLIC IP"

require 'fileutils' 

module OS
    # Try detecting Windows
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
end

Vagrant.configure(2) do |config|

  # http://fgrehm.viewdocs.io/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier") and not OS.windows?
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      type: :rsync,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  else
    puts "Run 'vagrant plugin install vagrant-cachier' to speed up provisioning."
  end

  provisioner = :ansible
  local_ansible = true

  config.vm.hostname = DIGITAL_OCEAN_HOSTNAME

  config.vm.define "digital_ocean", primary: true do |digital_ocean|
    digital_ocean.vm.box = "digital_ocean"
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    override.nfs.functional = false

    provider.client_id = DIGITAL_OCEAN_LOGIN
    provider.token = DIGITAL_OCEAN_TOKEN
    provider.image = "debian-8-x64"
    provider.region = "fra1"
    provider.size = "1gb" # Needed for installation .. after that is done, you can lower it in your droplet settings
  end

  # Temporarily disable syncing repo ..
  # ENV.delete('SYNC_REPO')

  if ENV['SYNC_REPO']
    config.vm.synced_folder ENV['SYNC_REPO'], "/home/vagrant/kohaclone", type: "rsync"
  end

  provisioner = :ansible_local
  config.vm.provision :shell, path: "tools/install-ansible.sh"

  config.vm.provision provisioner do |ansible|
    ansible.extra_vars = { ansible_ssh_user: "vagrant", testing: true }

    if ENV['SKIP_WEBINSTALLER']
      ansible.extra_vars.merge!({ skip_webinstaller: true })
    end

    if ENV['SYNC_REPO']
      ansible.extra_vars.merge!({ sync_repo: true });
    end

    if ENV['KOHA_ELASTICSEARCH']
      ansible.extra_vars.merge!({ elasticsearch: true });
    end

    if ENV['CREATE_ADMIN_USER']
      ansible.extra_vars.merge!({ create_admin_user: true });
    end

    ansible.playbook = "site.yml"
    ## Special variables needed for :ansible_local go here
    # We install our own ansible, which is newer
    ansible.install  = false
  end
  
  config.vm.post_up_message = "Welcome to KohaDevBox!\nSee https://github.com/digibib/kohadevbox for details"

end
