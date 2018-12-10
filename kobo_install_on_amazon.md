# Kobo toolbox on Amazon ECW

# Spin up a server.

- Get an Amazon AWS account
- Go to the AWS console (console.aws.amazon.com), go to the Compute -> EC2 page
- Launch a new EC2 instance (Launch Instance)
  - Select Ubuntu Server 16.04 LTS 64-bit
  - Select a t2.small instance (1 vCPU, 2GB RAM)
  - Give it at least 20GB of storage (50 is better)
  - Once the Amazon instance is running, you need to set up a security group before you can SSH into it. Add a rule for SSH, from any IP address. If this is the first time, create a *new* security group:
    - Add the following rules:
 
 SSH | TCP | port 22 | Anywhere
 HTTP | TCP | port 80 | Anywhere
 HTTPS | TCP | port 442 | Anywhere

  - Create a key pair (we used the downloaded .pem file provided by Amazon)
    
    - Amazon instances seem to require a public key .pem file (the normal id_rsa that you may already have doesn't appear in the list of selectable keys). Maybe there's a way to upload your normal id_rsa_pub...

# Set up domain name service

Now go the Amazon Route 53 console and create a Hosted Zone

- Copy the Amazon nameservers from NS row to your domain registrar (we use Namecheap, and in NAMESERVERS area enter Custom DNS and the four Amazon names (without the period at the end, i.e. ns-1333.awsdns-38.org and so on)
- Set two A records (example.com and www.example.com), both pointing to the IP address of your EC2 instance
- Set one CNAME (*.example.com, value = example.com)

# Connect to the server

ssh -i /path/to/mykey.pem ubuntu@example.com

Prep the server and create a user (we're using the name hot-admin as an example).

```
sudo adduser hot-admin    # Enter password, name, etc
sudo usermod -aG sudo hot-admin
sudo mkdir /home/hot-admin/.ssh
sudo cp .ssh/authorized_keys /home/hot-admin/.ssh/
sudo chown hot-admin /home/hot-admin/.ssh/authorized_keys
```

Now you can ```exit``` from your ssh session and ssh back in using your username

```
ssh -i .ssh/mykey.pem hot-admin@example.com
```

You have to set up Git with your username

```git config --global.user.name username```

Then

```
git clone https://github.com/ivangayton/setup-scripts/various
```
