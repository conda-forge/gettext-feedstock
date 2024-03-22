#!/bin/bash

set -euxo pipefail

mkdir -p ${PREFIX}/include
cp ./gettext-runtime/libasprintf/autosprintf.h ${PREFIX}/include/autosprintf.h

pushd ${PREFIX}/lib
if [[ "${target_platform}" == osx-* ]]; then
  ln -s libasprintf.*.dylib libasprintf.dylib
else
  ln -s libasprintf.so.* libasprintf.so
fi
popd

