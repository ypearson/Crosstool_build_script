#!/bin/sh

# sudo visudo and add these lines
# USER HOSTNAME = (root) NOPASSWD: /usr/bin/apt-get
# USER HOSTNAME = (root) NOPASSWD: /usr/bin/make

TC="arm-unknown-linux-gnueabi \
    arm-unknown-linux-uclibcgnueabi 
    arm-unknown-linux-uclibcgnueabihf"

DEST=.
CWD=$PWD
CTVER=1.20.0 # v1.21 doesn't seem to build correctly on Ubuntu 14.04
URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CTVER}.tar.bz2
XDIR=${HOME}/x-tools

if [ -d crosstool-ng-${CTVER} ]; then
   echo 'Deleting old crosstool-ng.'
   rm -rf crosstool-ng-${CTVER}
fi

if [ -d ${XDIR} ]; then
	echo 'Deleting old toolchain build.'
	chmod 777 -R ${XDIR}
	rm -rf ${XDIR}
fi

wget -qO- ${URL} | tar -C ${DEST} -xvjf -
sudo apt-get install -y gperf bison flex texinfo gawk libtool automake libncurses5-dev g++ libexpat1-dev

cd crosstool-ng-${CTVER}
./configure
make
sudo make install

for tc in $TC
do
	ct-ng $tc
	ct-ng build
done

cd ${XDIR}

for tc in $TC
do
	tar -czf ${tc}.tar.gz ${tc}
	mv ${tc}.tar.gz ${CWD}
done

cd ${CWD}
chmod 777 -R ${XDIR}
rm -rf ${XDIR}
