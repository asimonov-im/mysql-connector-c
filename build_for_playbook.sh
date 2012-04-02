#!/bin/bash
cmake -G "Unix Makefiles" --debug-trycompile -DCMAKE_INSTALL_PREFIX=`pwd`/../install -DCMAKE_TOOLCHAIN_FILE=PlayBookToolchain.cmake
make
