

MANUAL FOR SPIN UP AND PROVISION THE VIRTUAL MACHINE WITH VAGRANT:



NOTE:
	- I'm using Ubuntu 14.04 LTS.
	- Provision of the VM is done with shell scripting.
	- Everything is done from terminal.
	- Every bash script contains comments



1. Install VirtualBox (version: 4.3.36_Ubuntur105129)

apt-get install virtualbox


2. Install Vagrant (version: Vagrant 1.4.3)

apt-get install vagrant


3. Install Vagrant plugin (automatically installs the host's VirtualBox Guest Additions on the guest system for synced/shared folder)

vagrant plugin install vagrant-vbguest


4. Create directory to be a Vagrant environment

mkdir VAGRANT_JESSIE64 && cd VAGRANT_JESSIE64


5. Get Debian VM box for VirtualBox from "https://atlas.hashicorp.com/boxes/search", saved file will be named as "virtualbox.box"

wget "https://atlas.hashicorp.com/debian/boxes/jessie64/versions/8.4.0/providers/virtualbox.box"


6. Add box localy to Vagrant file

vagrant box add debian-jessie64 virtualbox.box


7. Vagrant will create ".vagrant" dir in your home directory. Edit file "/YOUR_HOME_DIR/.vagrant.d/boxes/jessie64/virtualbox/Vagrant" and uncomment following lines or You can simple delete file. 

#Vagrant.configure("2") do |config|
#  config.vm.synced_folder \
#    ".",
#    "/vagrant",
#    type: "rsync"
#end


8. Initializes the VAGRANT_JESSIE64 directory to be a Vagrant environment by creating an initial Vagrantfile

vagrant init debian-jessie64


9. Create directory "static" inside VAGRANT_JESSIE64 directory for testing of serving static files, put some static file in "static" directory

mkdir static

cp your_image.jpg static/


10. Put following scripts in VAGRANT_JESSIE64 directory

- provision_system_update.sh

- provision_http.sh

- provision_database.sh


11. Edit Vagrantfile and make a following changes, leave everything else by default

# Set locale for mongodb functionality
ENV['LC_ALL']="C"

# System update and upgrade
config.vm.provision :shell, path: "provision_system_update.sh"

# Install mongo database
config.vm.provision :shell, path: "provision_database.sh"		

# Install and configure nginx to server static page (will serve static files on every location on Web server)
config.vm.provision :shell, path: "provision_http.sh"			

# Forward port 8080 on host machine to port 80 on guest machine
config.vm.network :forwarded_port, guest: 80, host: 8080


12. Start/reload Vagrant VM with provision

vagrant up --provision

or

vagrant reload --provision


13. From Your local machine, test Web server by opening the following links

- http://localhost:8080

- http://localhost:8080/static/your_image.jpg






