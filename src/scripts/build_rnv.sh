#!/bin/bash
set -e

# Build rnv

cd libs/rnv-1.7.11
SRC_DIR=../..

echo "Building rnv..."

mkdir schema
cp $SRC_DIR/schema/schemas/styles/*.rnc schema/

echo "---"
echo "Running ./configure (this run will fail)"
emconfigure ./configure \
    --with-expat-inc ../expat-2.7.1/lib/ \
    --with-expat-lib ../expat-2.7.1/lib/.libs/ \
    --host=wasm32-unknown-emscripten \
    ac_cv_lib_expat_XML_SetDoctypeDeclHandler=yes \
    || true

echo "---"
echo "Running ./configure a second time (this run will work)" # Why?
emconfigure ./configure \
    --with-expat-inc=../expat-2.7.1/lib/ \
    --with-expat-lib=../expat-2.7.1/lib/.libs/ \
    --host=wasm32-unknown-emscripten

#  - Emit an ES Module
#  - Use `RNV` as the default export name
#  - Keep `FS` so we can put the input CSL into the virtual filesystem
#  - Turn off async compilation because it doesn't work in the Zotero client due to Content-Type issues
#    (non-Zotero users may consider reenabling this)
#  - Embed the schema/ directory
CFLAGS="-O3 \
        -sMODULARIZE \
        -sEXPORT_ES6 \
        -sEXPORT_NAME=RNV \
        -sEXPORTED_RUNTIME_METHODS=FS \
        -sWASM_ASYNC_COMPILATION=0 \
        --embed-file schema/"
emmake make CFLAGS="$CFLAGS" -j32

mkdir $SRC_DIR/dist
mv rnv $SRC_DIR/dist/rnv.mjs
mv rnv.wasm $SRC_DIR/dist/rnv.wasm
