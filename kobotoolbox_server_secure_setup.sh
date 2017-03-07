#!/bin/bash

echo please enter your domain name
read domain_name

# install docker-compose

git clone https://github.com/kobotoolbox/kobo-docker.git

sudo apt install -y letsencrypt

sudo letsencrypt certonly --standalone -d $domain_name -d www.$domain_name -d kf.$domain_name -d kc.$domain_name -d en.$domain_name

