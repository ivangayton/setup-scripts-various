#!/bin/bash

echo installing unzip and the dependencies for gdal
sudo apt -y install unzip
sudo apt-get -y build-dep gdal

echo downloading the Erdas SDK and patches
wget http://www.kyngchaos.com/files/macosxport/libecwj2-3.3-2006-09-06.zip &&\
    unzip libecwj2-3.3-2006-09-06.zip &&\
    wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3162/libecwj2-3.3-msvc90-fixes.patch &&\
    patch -p0< libecwj2-3.3-msvc90-fixes.patch &&\
    wget http://osgeo-org.1560.x6.nabble.com/attachment/5001530/0/libecwj2-3.3-wcharfix.patch &&\
    wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3366/libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
    cd libecwj2-3.3/ &&\
    patch -p0< ../libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
    patch -p1< ../libecwj2-3.3-wcharfix.patch

echo configuring the ecw library
./configure

echo making the ecw library; this will take a while
make

echo installing the ecw library
sudo make install

echo downloading the gdal sources
wget -c http://download.osgeo.org/gdal/2.2.1/gdal-2.2.1.tar.gz

echo unzipping the gdal source
tar -xzf gdal-2.2.1.tar.gz

echo stepping into gdal directory
cd gdal-2.2.1/

echo configuring gdal
./configure --with-python --with-spatialite --with-pg --with-curl --with-ecw=/usr/local

echo making the gdal binary; this will take a long time
make

echo installing gdal
sudo make install

echo configuring the gdal path
sudo ldconfig

echo
echo done! now run gdalinfo --formats | grep ECW to see if it worked
