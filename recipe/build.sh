#!/usr/bin/env bash

set -exuo pipefail

if [[ "$target_platform" == win* ]] ; then
  export PREFIX="$LIBRARY_PREFIX_U"
  export PATH="$PATH_OVERRIDE"

  # For the new msys2 platform, the libiconv stub library
  # naming scheme needs to be updated.

  cp $PREFIX/lib/iconv.lib $PREFIX/lib/libiconv.a

  # There are a zillion files in the build system in this package
  # that encode Windows-specific settings by checking that the Autoconf
  # host looks like mingw*. Unfortunately for us, here it now looks like
  # msys-... There are so many files that patching them individually
  # would be hugely annoying, but a mechanical update get us going.

  echo
  echo "Editing build files for msys ..."
  for namepat in "*.m4" Makefile.am configure.ac ; do
    find -name "$namepat" -print0 |xargs -0 sed -i -e 's/mingw\*/mingw* | msys*/g'
  done
  echo "... done"
  echo

  # Setup needed for autoreconf. Keep am_version sync'ed with meta.yaml.

  am_version=1.16
  export ACLOCAL=aclocal-$am_version
  export AUTOMAKE=automake-$am_version

  # We need to configure the "windres"/"rc" tool to apply preprocessing.
  # It also breaks if we don't use `--use-temp-file` -- looks like the 
  # Cygwin popen() call might not work on Windows.

  export RC="x86_64-w64-mingw32-windres --use-temp-file --preprocessor=x86_64-w64-mingw32-cpp --preprocessor-arg=-DRC_INVOKED"
  export WINDRES="$RC"

  # We need to get the stub libraries that let us link with system
  # DLLs, and host prefix headers for libiconv.

  export LDFLAGS="${LDFLAGS:-} -L$BUILD_PREFIX/Library/x86_64-w64-mingw32/sysroot/usr/lib -L$PREFIX/lib"
  export CPPFLAGS="${CPPFLAGS:-} -I$PREFIX/Library/include"

  autoreconf -vfi
else
  # Get an updated config.sub and config.guess
  cp $BUILD_PREFIX/share/libtool/build-aux/config.* build-aux/
  export CPP="$CC -E"
fi

./configure \
  --prefix=$PREFIX \
  --disable-static \
  --disable-csharp \
  --disable-dependency-tracking \
  --disable-java \
  --disable-native-java \
  --disable-openmp \
  --enable-fast-install \
  --without-emacs || { cat config.log; cat gettext-runtime/config.log; exit 1; }

make -j${CPU_COUNT}
