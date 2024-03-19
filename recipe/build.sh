#!/usr/bin/env bash

set -exuo pipefail

if [[ "$target_platform" == win* ]]; then
    export BUILD=x86_64-pc-mingw64
    export HOST=x86_64-pc-mingw64
else
    # Get an updated config.sub and config.guess
   cp $BUILD_PREFIX/share/libtool/build-aux/config.* build-aux/
   export CPP="$CC -E"
fi

./configure \
  --prefix=$PREFIX \
  --build=$BUILD \
  --host=$HOST \
  --disable-static \
  --disable-csharp \
  --disable-dependency-tracking \
  --disable-java \
  --disable-native-java \
  --disable-openmp \
  --enable-fast-install \
  --without-emacs || (cat config.log; cat gettext-runtime/config.log; exit 1)

# [[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}

find . -name '*.dll'
