#!/bin/bash

set -euxo pipefail

mkdir -p ${PREFIX}/include
cp ./gettext-runtime/intl/libintl.h ${PREFIX}/include/libintl.h

pushd ${PREFIX}/lib
if [[ "${target_platform}" == osx-* ]]; then
  ln -s libintl.*.dylib libintl.dylib
else
  ln -s libintl.so.* libintl.so
fi
popd
