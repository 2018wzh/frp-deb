#!/bin/bash
ARCH=amd64
VERSION=$(wget -qO- -t1 -T2 "https://api.github.com/repos/fatedier/frp/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g;s/v//g')
FILENAME="frp_"${VERSION}"_linux_"${ARCH}
URL="https://github.com/fatedier/frp/releases/download/v"${VERSION}"/"${FILENAME}".tar.gz"

mkdir build

rm -rfv ./build/*
rm -rfv ./frp/etc/frp/*
rm -rfv ./frp/usr/bin/*
rm -rfv ./DEBIAN/control

sed 's/%ARCH%/'${ARCH}'/g;s/%VERSION%/'${VERSION}'/g' DEBIAN/control.template | tee ./DEBIAN/control

wget ${URL} -O ./build/frp.tar.gz

cd ./build
tar xvf frp.tar.gz
mv ${FILENAME}/*.toml ../frp/etc/frp/
chmod +x ${FILENAME}/frp*
mv ${FILENAME}/frp* ../frp/usr/bin/

dpkg-deb --build frp out/$FILENAME.deb
