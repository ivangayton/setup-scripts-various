#!/bin/bash
# This is a script to install GDAL 2.2.1 with ERDAS ECW file format support
# in Ubuntu 16.04.
# This is purely a quick convenience hack. GDAL versions will change and
# this script will quickly become obsolete, not to mention the fact that it
# depends on some external files being available on the KyngChaos site!


echo installing unzip and the dependencies for gdal
echo make sure you have sources enabled for all repos

sudo apt -y install unzip
sudo apt-get -y build-dep gdal

echo downloading the Erdas SDK and patches
if [ ! -f libecwj2-3.3-2006-09-06.zip ]; then
    echo downloading the Erdas file from Kyng Chaos
    wget http://www.kyngchaos.com/files/macosxport/libecwj2-3.3-2006-09-06.zip
else echo looks like you already have the Erdas SDK file
     sleep 5
fi

if [ ! -f libecwj2-3.3-msvc90-fixes.patch ]; then
    echo downloading a patch from OSGEO for the Erdas SDK
    wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3162/libecwj2-3.3-msvc90-fixes.patch
else echo looks like you already have the OSGEO patch
     sleep 5
fi

echo Unzipping the libecw file
unzip libecwj2-3.3-2006-09-06.zip

echo applying the OSGEO patch to the Erdas SDK file
patch -p0< libecwj2-3.3-msvc90-fixes.patch

if [ ! -f libecwj2-3.3-wcharfix.patch ]; then
    echo downloading a character fix patch from OSGEO for the Erdas SDK
    wget http://osgeo-org.1560.x6.nabble.com/attachment/5001530/0/libecwj2-3.3-wcharfix.patch
else echo looks like you already have the character fix patch
     sleep 5
fi

if [ ! -f libecwj2-3.3-wcharfix.patch ]; then
    echo downloading a memory patch from OSGEO for the Erdas SDK
    wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3366/libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch
else echo looks like you already have the memory patch
     sleep 1
fi

echo stepping into the libecw folder
cd libecwj2-3.3/

echo applying patches
patch -p0< ../libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch
patch -p1< ../libecwj2-3.3-wcharfix.patch

echo configuring the ecw library
./configure

echo making the ecw library; this will take a while
make

echo installing the ecw library
sudo make install

echo stepping out of the libecw folder
cd ..
pwd

sleep 10

if [ ! -f gdal-2.2.1.tar.gz ]; then
    echo downloading the gdal sources
    wget -c http://download.osgeo.org/gdal/2.2.1/gdal-2.2.1.tar.gz
else echo looks like you already have the gdal sources
     sleep 1
fi

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
