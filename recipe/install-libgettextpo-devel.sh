#!/bin/bash

set -euxo pipefail

mkdir -p ${PREFIX}/include
cp ./gettext-tools/libgettextpo/gettext-po.h ${PREFIX}/include/gettext-po.h

pushd ${PREFIX}/lib
if [[ "${target_platform}" == osx-* ]]; then
  ln -s libgettextpo.*.dylib libgettextpo.dylib
else
  ln -s libgettextpo.so.* libgettextpo.so
fi
popd

