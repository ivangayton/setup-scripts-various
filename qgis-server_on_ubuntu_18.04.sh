# Install QGIS Server on Ubuntu 18.04

sudo apt update
sudo apt -y upgrade
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 314DF160
sudo apt update
sudo apt -y install qgis-server python-qgis

sudo apt -y install nginx

# For now using scgiwrap, but should later use spawn-fcgi
sudo apt -y install fcgiwrap

# Add to /etc/nginx/sites-available/default:

#  location /qgisserver {
#      gzip           off;
#      include        fastcgi_params;
#      fastcgi_pass   unix:/var/run/fcgiwrap.socket;
#      fastcgi_param  SCRIPT_FILENAME /usr/lib/cgi-bin/qgis_mapserv.fcgi;
#  }

sudo service nginx restart
sudo service fcgiwrap restart

# copy a QGIS map folder over to the server like so:
# scp -r qgis-server_test_map/ hot-admin@diffalt.org:~/

# Then try going to

# http://DOMAIN_NAME/qgisserver?MAP=/home/hot-admin/qgis-server_test_map/Dar_qgis-server_test.qgs&LAYERS=subwards&SERVICE=WMS&REQUEST=GetMap&CRS=EPSG:4326&WIDTH=800&HEIGHT=600

# Of course, the name of the folder, map, and layers needs to be consistent with what you've uploaded
