#!/bin/bash

sudo apt install unzip
sudo apt-get build-dep gdal

wget http://www.kyngchaos.com/files/macosxport/libecwj2-3.3-2006-09-06.zip &&\
    unzip libecwj2-3.3-2006-09-06.zip &&\
    wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3162/libecwj2-3.3-msvc90-fixes.patch &&\
    patch -p0< libecwj2-3.3-msvc90-fixes.patch &&\
    wget http://osgeo-org.1560.x6.nabble.com/attachment/5001530/0/libecwj2-3.3-wcharfix.patch &&\
    wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3366/libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
    cd libecwj2-3.3/ &&\
    patch -p0< ../libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
    patch -p1< ../libecwj2-3.3-wcharfix.patch &&\
    ./configure &&\
    make

sudo make install

wget -c http://download.osgeo.org/gdal/2.2.1/gdal-2.2.1.tar.gz
tar -xzf gdal-2.2.1.tar.gz
cd gdal-2.2.1/
./configure --with-python --with-spatialite --with-pg --with-curl --with-ecw=/usr/local

make

sudo make install
sudo ldconfig

# now run gdalinfo --formats | grep ECW to see if it worked
