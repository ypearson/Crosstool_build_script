#!/bin/sh

# sudo visudo and add these lines
# USER HOSTNAME = (root) NOPASSWD: /usr/bin/apt-get
# USER HOSTNAME = (root) NOPASSWD: /usr/bin/make

TC=arm-unknown-linux-gnueabi
DEST=.
CTVER=1.20.0 # v1.21 doesn't seem build correctly on Ubuntu 14.04
URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CTVER}.tar.bz2

rm -rf ${HOME}/x-tools

wget -qO- ${URL} | tar -C ${DEST} -xvjf -

sudo apt-get install -y gperf bison flex texinfo gawk libtool automake libncurses5-dev g++ libexpat1-dev

cd crosstool-ng-${CTVER}
./configure
make
sudo make install

ct-ng ${TC}
ct-ng build

cd ${HOME}/x-tools
tar -czf ${TC}.tar.gz ${TC}





