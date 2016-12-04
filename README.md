# KohaDevBox on the DigitalOcean

Create a development environment for the Koha ILS project on the [DigitalOcean](https://cloud.digitalocean.com/droplets) using new droplet (scaling available). It uses Vagrant and Ansible to set up a VirtualBox. It targets the following tasks:

 * Run all t/ and t/db_dependent tests
 * Sign off patches
 * QA patches
 * Release

##### To customize the deployment, please see [the original kohadevbox](https://github.com/digibib/kohadevbox#environment-variables)

Install
-------
Install the provider plugin using the Vagrant command-line interface:

`vagrant plugin install vagrant-digitalocean`

Setting up a droplet
--------------------

1. Obtain [DigitalOcean API token](https://cloud.digitalocean.com/settings/api/tokens)
2. Write it down into file Vagrantfile under DIGITAL_OCEAN_TOKEN variable
3. Fill up also DIGITAL_OCEAN_LOGIN
4. Run `vagrant up --provision` as usual
5. If you want to rebuild the VM and keep your public IP, run just `vagrant rebuild`
