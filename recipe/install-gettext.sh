#!/bin/bash

set -euxo pipefail

make install

# This overlaps with readline:
rm -rf ${PREFIX}/share/info/dir

find $PREFIX -name '*.la' -delete
