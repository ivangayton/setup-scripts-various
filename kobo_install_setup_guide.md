# Use Kobo Install on Digital Ocean

Get a server (Ubuntu 18.04, 2GB RAM).

```git clone https://github.com/setup-scripts-various

sudo ./docker_install.sh
```

After that completes

```sudo usermod -aG docker $USER```

Then reboot (unless you can figure out how to restart the docker-daemon)

Test docker with ```docker run hello-world```

