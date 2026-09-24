#!/usr/bin/env bash

set -exuo pipefail

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* build-aux/
export CPP="$CC -E"

# libcurl pulls ncurses into host; --disable-curses keeps libtextstyle's
# built-in terminal handling rather than adding an ncurses dependency.
./configure \
  --prefix=$PREFIX \
  --build=$BUILD \
  --host=$HOST \
  --with-libiconv-prefix=$PREFIX \
  --disable-static \
  --disable-csharp \
  --disable-curses \
  --disable-dependency-tracking \
  --disable-java \
  --disable-native-java \
  --disable-openmp \
  --enable-fast-install \
  --without-emacs || (cat config.log; cat gettext-runtime/config.log; exit 1)

make -j${CPU_COUNT}

