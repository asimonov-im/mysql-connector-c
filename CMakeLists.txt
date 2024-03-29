# Copyright (C) 2006 MySQL AB
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

CMAKE_MINIMUM_REQUIRED(VERSION 2.6.0 FATAL_ERROR)
IF(COMMAND CMAKE_POLICY)
  CMAKE_POLICY(SET CMP0003 NEW)
ENDIF(COMMAND CMAKE_POLICY)

PROJECT(libmysql)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE "Release")
ENDIF(NOT CMAKE_BUILD_TYPE)

# This reads user configuration, generated by configure.js.
IF(WIN32 AND EXISTS ${CMAKE_SOURCE_DIR}/win/configure.data)
  INCLUDE(${CMAKE_SOURCE_DIR}/win/configure.data)
ENDIF(WIN32 AND EXISTS ${CMAKE_SOURCE_DIR}/win/configure.data)

IF(CMAKE_COMPILER_IS_GNUCXX)
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -fno-rtti -fno-exceptions")
  SET(CMAKE_CXX_COMPILER "${CMAKE_C_COMPILER}" CACHE INTERNAL "C++ Compiler" FORCE)
ENDIF(CMAKE_COMPILER_IS_GNUCXX)


SET(PROTOCOL_VERSION "10")
SET(SHARED_LIB_VERSION "16.0.0")

# This roughly corresponds to the MySQL server version we work with
SET(CONNECTOR_C_MAJOR "6")
SET(CONNECTOR_C_MINOR "0")
SET(CONNECTOR_C_PATCH "2")
SET(CONNECTOR_C_LEVEL "")

# XXX: these need to go away -- we're not the server.
SET(MYSQL_SERVER_VERSION "6.0.0")
SET(MYSQL_VERSION_ID     "60000")

SET(CONNECTOR_C_NUMERIC_VERSION "${CONNECTOR_C_MAJOR}.${CONNECTOR_C_MINOR}.${CONNECTOR_C_PATCH}")
SET(CONNECTOR_C_VERSION         "${CONNECTOR_C_NUMERIC_VERSION}${CONNECTOR_C_LEVEL}")

IF(WIN32)
  FILE(WRITE "${CMAKE_SOURCE_DIR}/win/version.cmake" "SET(CONNECTOR_PRODUCT_VERSION ${CONNECTOR_C_NUMERIC_VERSION})
SET(CONNECTOR_PRODUCT_LEVEL ${CONNECTOR_C_LEVEL})")
ENDIF(WIN32)

SET(MYSQL_TCP_PORT_DEFAULT "3306")
IF(NOT MYSQL_TCP_PORT)
  SET(MYSQL_TCP_PORT ${MYSQL_TCP_PORT_DEFAULT})
  SET(MYSQL_TCP_PORT_DEFAULT "0")
ENDIF(NOT MYSQL_TCP_PORT)
IF(NOT MYSQL_UNIX_ADDR)
  SET(MYSQL_UNIX_ADDR "/tmp/mysql.sock")
ENDIF(NOT MYSQL_UNIX_ADDR)
IF(NOT COMPILATION_COMMENT)
  SET(COMPILATION_COMMENT "Source distribution")
ENDIF(NOT COMPILATION_COMMENT)

CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/include/mysql_version.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/include/mysql_version.h @ONLY)

IF(NOT SKIP_SSL AND NOT WITH_OPENSSL)
  ADD_DEFINITIONS(-DHAVE_YASSL -DYASSL_PURE_C -DHAVE_OPENSSL)
ENDIF(NOT SKIP_SSL AND NOT WITH_OPENSSL)

# Set debug options
SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DFORCE_INIT_OF_VARS")

# Do not use SAFEMALLOC for Windows builds, as Debug CRT has the same
# functionality Neither SAFE_MUTEX works on Windows and it has been
# explicitely undefined in my_pthread.h
IF(NOT WIN32)
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DSAFEMALLOC -DSAFE_MUTEX")
  SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DSAFEMALLOC -DSAFE_MUTEX")
ENDIF(NOT WIN32)


SET(localstatedir "C:\\mysql\\data")

IF(__NT__)
  ADD_DEFINITIONS(-D__NT__)
ENDIF(__NT__)
IF(CYBOZU)
  ADD_DEFINITIONS(-DCYBOZU)
ENDIF(CYBOZU)

IF(EXTRA_DEBUG)
  ADD_DEFINITIONS(-D EXTRA_DEBUG)
ENDIF(EXTRA_DEBUG)

IF(ENABLED_DEBUG_SYNC)
  ADD_DEFINITIONS(-D ENABLED_DEBUG_SYNC)
ENDIF(ENABLED_DEBUG_SYNC)
SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DENABLED_DEBUG_SYNC")
SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DENABLED_DEBUG_SYNC")

IF(BACKUP_TEST)
  ADD_DEFINITIONS(-D BACKUP_TEST)
ENDIF(BACKUP_TEST)

# in some places we use DBUG_OFF
SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DDBUG_OFF")
SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -DDBUG_OFF")
SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DDBUG_OFF")
SET(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -DDBUG_OFF")

# enable debug info also in Release build, and create PDB to be able to analyze crashes
IF(WIN32)
  SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi")
  SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Zi")
  SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /debug")
ENDIF(WIN32)


IF(CMAKE_GENERATOR MATCHES "Visual Studio 7")
    # VS2003 needs the /Op compiler option to disable floating point
# optimizations
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Op")
    SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Op")
    SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /Op")
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /Op")
    SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Op")
    SET(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} /Op")
ENDIF(CMAKE_GENERATOR MATCHES "Visual Studio 7")

#TODO: update the code and remove the disabled warnings
IF(WIN32)
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4800 /wd4805")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4800 /wd4805")
ENDIF(WIN32)

# Disable warnings in Visual Studio 8 and above
IF(MSVC AND NOT CMAKE_GENERATOR MATCHES "Visual Studio 7")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /wd4996")
    SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /wd4996")
    SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /wd4996")
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /wd4996")
    SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /wd4996")
    SET(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} /wd4996")
ENDIF(MSVC AND NOT CMAKE_GENERATOR MATCHES "Visual Studio 7")


# Settings for Visual Studio 7 and above.  
IF(MSVC)
    # replace /MDd with /MTd
    STRING(REPLACE "/MD"  "/MT"  CMAKE_C_FLAGS_RELEASE          ${CMAKE_C_FLAGS_RELEASE})
    STRING(REPLACE "/MD"  "/MT"  CMAKE_C_FLAGS_RELWITHDEBINFO   ${CMAKE_C_FLAGS_RELWITHDEBINFO})
    STRING(REPLACE "/MDd" "/MTd" CMAKE_C_FLAGS_DEBUG            ${CMAKE_C_FLAGS_DEBUG})
    STRING(REPLACE "/MDd" "/MTd" CMAKE_C_FLAGS_DEBUG_INIT       ${CMAKE_C_FLAGS_DEBUG_INIT})

    STRING(REPLACE "/MD"  "/MT"  CMAKE_CXX_FLAGS_RELEASE        ${CMAKE_CXX_FLAGS_RELEASE})
    STRING(REPLACE "/MD"  "/MT"  CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
    STRING(REPLACE "/MDd" "/MTd" CMAKE_CXX_FLAGS_DEBUG          ${CMAKE_CXX_FLAGS_DEBUG})
    STRING(REPLACE "/MDd" "/MTd" CMAKE_CXX_FLAGS_DEBUG_INIT     ${CMAKE_CXX_FLAGS_DEBUG_INIT})

    # generate map files, set stack size (see bug#20815)
    SET(thread_stack_size 1048576)
    SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /STACK:${thread_stack_size}")
    ADD_DEFINITIONS(-DPTHREAD_STACK_MIN=${thread_stack_size})

    # remove support for Exception handling
    STRING(REPLACE "/GX"   "" CMAKE_CXX_FLAGS            ${CMAKE_CXX_FLAGS})
    STRING(REPLACE "/EHsc" "" CMAKE_CXX_FLAGS            ${CMAKE_CXX_FLAGS})
    STRING(REPLACE "/EHsc" "" CMAKE_CXX_FLAGS_INIT       ${CMAKE_CXX_FLAGS_INIT})
    STRING(REPLACE "/EHsc" "" CMAKE_CXX_FLAGS_DEBUG_INIT ${CMAKE_CXX_FLAGS_DEBUG_INIT})
    
    # Mark 32 bit executables large address aware so they can 
    # use > 2GB address space
    IF(CMAKE_SIZEOF_VOID_P MATCHES 4)
      SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE")
    ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 4)
    
    # Disable automatic manifest generation.
    STRING(REPLACE "/MANIFEST" "/MANIFEST:NO" CMAKE_EXE_LINKER_FLAGS 
    	   ${CMAKE_EXE_LINKER_FLAGS})
    # Explicitly disable it since it is the default for newer versions of VS
    STRING(REGEX MATCH "MANIFEST:NO" tmp_manifest ${CMAKE_EXE_LINKER_FLAGS})
    IF(NOT tmp_manifest)
        SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /MANIFEST:NO")
    ENDIF(NOT tmp_manifest)
ENDIF(MSVC)

IF(WIN32)
  ADD_DEFINITIONS("-D_WINDOWS -D__WIN__ -D_CRT_SECURE_NO_DEPRECATE")
ENDIF(WIN32)

# This definition is necessary to work around a bug with Intellisense
# described here: http://tinyurl.com/2cb428.  Syntax highlighting is important
# for proper debugger functionality.
IF(WIN32 AND CMAKE_SIZEOF_VOID_P MATCHES 8)
   MESSAGE(STATUS "Detected 64-bit platform.")
   ADD_DEFINITIONS("-D_WIN64")
ENDIF(WIN32 AND CMAKE_SIZEOF_VOID_P MATCHES 8)

IF(EMBED_MANIFESTS)
    # Search for the tools (mt, makecat, signtool) necessary for embedding
    # manifests and signing executables with the MySQL AB authenticode cert.
    #
    # CMake will first search it's defaults (CMAKE_FRAMEWORK_PATH, 
    # CMAKE_APPBUNDLE_PATH, CMAKE_PROGRAM_PATH and the system PATH) followed 
    # by the listed paths which are the current possible defaults and should be
    # updated when necessary.  
    # 
    # The custom manifests are designed to be compatible with all mt versions.
    # The MySQL AB Authenticode certificate is available only internally.  
    # Others should store a single signing certificate in a local cryptographic
    # service provider and alter the signtool command as necessary.
    FIND_PROGRAM(HAVE_MANIFEST_TOOL NAMES mt
                 PATHS
                 "$ENV{PROGRAMFILES}/Microsoft Visual Studio 8/VC/bin"
                 "$ENV{PROGRAMFILES}/Microsoft Visual Studio 8/Common7/Tools/Bin"
                 "$ENV{PROGRAMFILES}/Microsoft Visual Studio 8/SDK/v2.0/Bin")
    FIND_PROGRAM(HAVE_CATALOG_TOOL NAMES makecat
                 PATHS
                 "$ENV{PROGRAMFILES}/Microsoft Visual Studio 8/Common7/Tools/Bin")
    FIND_PROGRAM(HAVE_SIGN_TOOL NAMES signtool
                 PATHS
                 "$ENV{PROGRAMFILES}/Microsoft Visual Studio 8/Common7/Tools/Bin"
                 "$ENV{PROGRAMFILES}/Microsoft Visual Studio 8/SDK/v2.0/Bin")

    IF(HAVE_MANIFEST_TOOL)
        MESSAGE(STATUS "Found Mainfest Tool.")
    ELSE(HAVE_MANIFEST_TOOL)
        MESSAGE(FATAL_ERROR "Manifest tool, mt.exe, can't be found.")
    ENDIF(HAVE_MANIFEST_TOOL)
    IF(HAVE_CATALOG_TOOL)
        MESSAGE(STATUS "Found Catalog Tool.")
    ELSE(HAVE_CATALOG_TOOL)
        MESSAGE(FATAL_ERROR "Catalog tool, makecat.exe, can't be found.")
    ENDIF(HAVE_CATALOG_TOOL)
    IF(HAVE_SIGN_TOOL)
        MESSAGE(STATUS "Found Sign Tool. Embedding custom manifests and signing executables.")
    ELSE(HAVE_SIGN_TOOL)
        MESSAGE(FATAL_ERROR "Sign tool, signtool.exe, can't be found.")
    ENDIF(HAVE_SIGN_TOOL)

    # Set the processor architecture.
    IF(CMAKE_GENERATOR MATCHES "Visual Studio 8 2005 Win64")
    	SET(PROCESSOR_ARCH "amd64") 
    ELSE(CMAKE_GENERATOR MATCHES "Visual Studio 8 2005 Win64")
    	SET(PROCESSOR_ARCH "X86")
    ENDIF(CMAKE_GENERATOR MATCHES "Visual Studio 8 2005 Win64")
ENDIF(EMBED_MANIFESTS)

IF(WIN32)
  SET(SHAREDIR "share")
  # XXX is this still a useful default?
  SET(DEFAULT_CHARSET_HOME "C:/mysql/")
ELSE(WIN32)
  SET(SHAREDIR "${CMAKE_INSTALL_PREFIX}/share/mysql")
  SET(DEFAULT_CHARSET_HOME "${CMAKE_INSTALL_PREFIX}")
ENDIF(WIN32)

INCLUDE(${CMAKE_SOURCE_DIR}/CMakePlatformTests.txt)
CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/include/my_config.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/include/my_config.h)

ADD_SUBDIRECTORY(vio)
ADD_SUBDIRECTORY(extlib/dbug)
ADD_SUBDIRECTORY(strings)
ADD_SUBDIRECTORY(extlib/regex)
IF(WITH_EXTERNAL_ZLIB)
  INCLUDE(FindZLIB)
  IF(NOT ZLIB_FOUND)
    MESSAGE(FATAL_ERROR "Unable to find external Zlib library and headers.")
  ENDIF(NOT ZLIB_FOUND)
ELSE(WITH_EXTERNAL_ZLIB)
  SET(ZLIB_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/extlib/zlib")
  ADD_SUBDIRECTORY(extlib/zlib)
ENDIF(WITH_EXTERNAL_ZLIB)
ADD_DEFINITIONS(-D HAVE_COMPRESS)

ADD_SUBDIRECTORY(mysys)
IF(NOT SKIP_SSL)
  IF(NOT WITH_OPENSSL)
    ADD_SUBDIRECTORY(extlib/yassl)
    ADD_SUBDIRECTORY(extlib/yassl/taocrypt)
  ELSE(NOT WITH_OPENSSL)
    INCLUDE(FindOpenSSL)
    IF(OPENSSL_FOUND)
      FIND_LIBRARY(OPENSSL_LIBCRYPTO NAMES crypto libeay32)
      ADD_DEFINITIONS(-DHAVE_OPENSSL)
    ENDIF(OPENSSL_FOUND)
  ENDIF(NOT WITH_OPENSSL)
ENDIF(NOT SKIP_SSL)
ADD_SUBDIRECTORY(libmysql)
ADD_SUBDIRECTORY(tests)
ADD_SUBDIRECTORY(unittest/mytap)
ADD_SUBDIRECTORY(unittest/examples)
ADD_SUBDIRECTORY(unittest/libmysql)
ADD_SUBDIRECTORY(unittest/mysys)
ADD_SUBDIRECTORY(mysql_config)

#
# Necessary for 'make test' to work
# 
ENABLE_TESTING()

#
# Installation
#
IF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  SET(CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/mysql"
      CACHE PATH "Connector/C install prefix" FORCE)
ENDIF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)

INSTALL(DIRECTORY "include/"
        DESTINATION "include/mysql"
        FILES_MATCHING PATTERN "*.h")

# ----------------------------------------------------------------------
# Create package script
# ----------------------------------------------------------------------

IF(NOT CONNECTOR_PLATFORM)
  IF(WIN32)
    IF(CMAKE_SIZEOF_VOID_P MATCHES 8)
      SET(CONNECTOR_PLATFORM "winx64") 
    ELSE(CMAKE_SIZEOF_VOID_P MATCHES 8)
      SET(CONNECTOR_PLATFORM "win32") 
    ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 8)
  ELSE(WIN32)
    SET(CONNECTOR_PLATFORM "unknown")
  ENDIF(WIN32)
ENDIF(NOT CONNECTOR_PLATFORM)

INCLUDE(InstallRequiredSystemLibraries)

SET(CPACK_PACKAGE_VERSION_MAJOR ${CONNECTOR_C_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${CONNECTOR_C_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${CONNECTOR_C_PATCH})

IF(NOT EXTRA_NAME_SUFFIX)
  SET(EXTRA_NAME_SUFFIX "")
ENDIF(NOT EXTRA_NAME_SUFFIX)

SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Connector/C (libmysql), a library for connecting to MySQL servers.")
SET(CPACK_PACKAGE_NAME                "mysql-connector-c${EXTRA_NAME_SUFFIX}")
SET(CPACK_PACKAGE_VENDOR              "Sun Microsystems, Inc.")
IF(EXISTS "COPYING")
  SET(CPACK_RESOURCE_FILE_LICENSE     "COPYING")
ELSE(EXISTS "COPYING")
  SET(CPACK_RESOURCE_FILE_LICENSE     "LICENSE.mysql")
ENDIF(EXISTS "COPYING")
SET(CPACK_PACKAGE_DESCRIPTION_FILE    "README")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME    "${CPACK_PACKAGE_NAME}-${CONNECTOR_C_VERSION}")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY   "${CPACK_PACKAGE_NAME}-${CONNECTOR_C_VERSION}-${CONNECTOR_PLATFORM}")
IF(WIN32)
  SET(CPACK_GENERATOR                 "ZIP")
  SET(CPACK_PACKAGE_FILE_NAME         "${CPACK_PACKAGE_NAME}-noinstall-${CONNECTOR_C_VERSION}-${CONNECTOR_PLATFORM}")
ELSE(WIN32)
  SET(CPACK_GENERATOR                 "TGZ")
  SET(CPACK_PACKAGE_FILE_NAME         "${CPACK_PACKAGE_INSTALL_DIRECTORY}")
ENDIF(WIN32)

INSTALL(FILES "README" "COPYING" "LICENSE.mysql" "EXCEPTIONS-CLIENT" "ChaneLog" DESTINATION "." OPTIONAL)

INCLUDE(CPack)
