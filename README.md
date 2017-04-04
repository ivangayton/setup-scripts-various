# setup-scripts-various
Documenting the setup process for servers I use. Ultimately creating provisioning scripts for servers.

## Install Kobo Toolbox on a cloud server using the script in this repo:
- Get a domain name from a vendor (I used NameCheap but use whatever you like).
- Configure the domain on the vendor's site to use your hosting provider's nameserver (well, do this: https://www.digitalocean.com/community/tutorials/how-to-point-to-digitalocean-nameservers-from-common-domain-registrars).
- Spin up a new Ubuntu 16.04, minimum 2GB of RAM (it won't work with less).  I used Digital Ocean $20/month droplet, but you can use Amazon AWS, RackSpace, Linode, or whatever.
- configure the DNS on your hosting provider's site to connect your domain name to your server (well, do this: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-host-name-with-digitalocean)
- wait until the DNS propagates (likely not more than a day, in my experience usually a few hours)
- Log into your server, create a user with sudo privileges, and ssh into the new user (well, do this: https://www.digitalocean.com/community/tutorials/how-to-connect-to-your-droplet-with-ssh and this: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04)
- Run the following commands: 
`git clone https://github.com/ivangayton/setup-scripts-various.git`
`cd setup_scripts_various`
`./kobotoolbox_secured_server_docker_install`

- Answer the questions my script asks you (domain name, username and password for your initial Kobo user, and support email address; do try to type all of these accurately)
- Answer the questions on the LetsEncrypt dialogue that the script will launch (your email address and your agreement to the ToS)
- Wait while a bunch of gobbledygook whizzes by, hopefully ending with a message suggesting that you try out your new server
- Give it a minute for the server to actually initialize
- Sit back and enjoy Kobo goodness.