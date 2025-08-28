#!/bin/bash
set -e

# Build Expat as a library for use in rnv

cd libs/expat-2.7.1
echo "Building Expat..."

./buildconf.sh
emconfigure ./configure --host=none-none-none --without-xmlwf --without-docbook CFLAGS=-O3
rm -f a.out*
emmake make -j32
