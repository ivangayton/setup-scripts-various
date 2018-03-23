#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt dist-upgrade

git clone https://github.com/opendronemap/opendronemap.git

cd opendronemap

./configure.sh install

