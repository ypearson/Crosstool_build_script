#!/bin/sh

set -e

TC="arm-unknown-eabi \
	arm-unknown-linux-uclibcgnueabi
	arm-unknown-linux-gnueabi
	arm-unknown-linux-uclibcgnueabihf"
DEST=.
CWD=$PWD
CTVER=1.20.0 # v1.21 doesn't seem to build correctly on Ubuntu 14.04
URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CTVER}.tar.bz2
XDIR=${CWD}/crosstool-ng-${CTVER}/x-tools
CROSSTOOLPATH=$PWD/crosstool
CT=$CROSSTOOLPATH/bin/ct-ng
PATH="/usr/bin":$PATH # make sure latest makeinfo/texinfo runs

if [ -d crosstool-ng-${CTVER} ]; then
   echo 'Deleting old crosstool-ng.'
   chmod 777 -R crosstool-ng-${CTVER}
   rm -rf crosstool-ng-${CTVER}
fi

if [ -d ${XDIR} ]; then
	echo 'Deleting old toolchain build.'
	chmod 777 -R ${XDIR}
	rm -rf ${XDIR}
fi

wget -qO- ${URL} | tar -C ${DEST} -xvjf -
#sudo apt-get install -y gperf bison flex texinfo gawk libtool automake libncurses5-dev g++ libexpat1-dev python2.7-dev make

cd crosstool-ng-${CTVER}
./configure --prefix ${CROSSTOOLPATH} 
make
make install

for tc in $TC
do
  $CT distclean
  $CT defconfig DEFCONFIG=${PWD}/../$tc.defconfig
  $CT build
  cd ${XDIR}
  tar -czf ${tc}.tar.gz ${tc}
  mv ${tc}.tar.gz ${CWD}
  cd ${CWD}/crosstool-ng-${CTVER}
done

cd ${CWD}
chmod 777 -R ${XDIR}
rm -rf ${XDIR}
