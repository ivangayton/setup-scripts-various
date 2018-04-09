#!/bin/bash

sudo docker exec -i -t kobodocker_nginx_1 /bin/bash

curl -o /etc/nginx/conf.d/nginx_site_https.conf http://zesty.ca/nginx_site_https.conf

service nginx reload

useradd -m koboviewer
cd /home/koboviewer
git clone https://github.com/zestyping/koboviewer
cd koboviewer
chown -R koboviewer.koboviewer .

apt update
apt install python3-pip
pip3 install -r requirements.txt

su - koboviewer
cd koboviewer
nohup ./run &
