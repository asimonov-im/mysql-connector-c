#!/bin/bash
rm -f CMakeCache.txt
cmake -G "Unix Makefiles" --debug-trycompile -DCMAKE_INSTALL_PREFIX=`pwd`/../install -DCMAKE_TOOLCHAIN_FILE=PlayBookToolchain.cmake
make install

