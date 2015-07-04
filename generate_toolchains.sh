#!/bin/sh

# sudo visudo and add these lines
# USER HOSTNAME = (root) NOPASSWD: /usr/bin/apt-get
# USER HOSTNAME = (root) NOPASSWD: /usr/bin/make

TC="arm-unknown-linux-gnueabi \
    arm-unknown-linux-uclibcgnueabi 
    arm-unknown-linux-uclibcgnueabihf"

DEST=.
CTVER=1.20.0 # v1.21 doesn't seem build correctly on Ubuntu 14.04
URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CTVER}.tar.bz2

wget -qO- ${URL} | tar -C ${DEST} -xvjf -

sudo apt-get install -y gperf bison flex texinfo gawk libtool automake libncurses5-dev g++ libexpat1-dev

rm -rf ${HOME}/x-tools
cd crosstool-ng-${CTVER}
./configure
make
sudo make install


for tc in $TC
do
	ct-ng $tc
	ct-ng build
done

cd ${HOME}/x-tools

for tc in $TC
do
	tar -czf ${tc}.tar.gz ${tc}
done
