# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.6

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canoncical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/cteam/BuildStepper/bootstrap-dep/inst/bin/cmake

# The command to remove a file.
RM = /home/cteam/BuildStepper/bootstrap-dep/inst/bin/cmake -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /home/cteam/BuildStepper/bootstrap-dep/inst/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /tmp/bootstrap-dir.5535/source

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /tmp/bootstrap-dir.5535/source

# Include any dependencies generated for this target.
include unittest/mysys/CMakeFiles/my_atomic-t.dir/depend.make

# Include the progress variables for this target.
include unittest/mysys/CMakeFiles/my_atomic-t.dir/progress.make

# Include the compile flags for this target's objects.
include unittest/mysys/CMakeFiles/my_atomic-t.dir/flags.make

unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o: unittest/mysys/CMakeFiles/my_atomic-t.dir/flags.make
unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o: unittest/mysys/my_atomic-t.c
	$(CMAKE_COMMAND) -E cmake_progress_report /tmp/bootstrap-dir.5535/source/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o"
	cd /tmp/bootstrap-dir.5535/source/unittest/mysys && /usr/sfw/bin/gcc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o   -c /tmp/bootstrap-dir.5535/source/unittest/mysys/my_atomic-t.c

unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/my_atomic-t.dir/my_atomic-t.c.i"
	cd /tmp/bootstrap-dir.5535/source/unittest/mysys && /usr/sfw/bin/gcc  $(C_DEFINES) $(C_FLAGS) -E /tmp/bootstrap-dir.5535/source/unittest/mysys/my_atomic-t.c > CMakeFiles/my_atomic-t.dir/my_atomic-t.c.i

unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/my_atomic-t.dir/my_atomic-t.c.s"
	cd /tmp/bootstrap-dir.5535/source/unittest/mysys && /usr/sfw/bin/gcc  $(C_DEFINES) $(C_FLAGS) -S /tmp/bootstrap-dir.5535/source/unittest/mysys/my_atomic-t.c -o CMakeFiles/my_atomic-t.dir/my_atomic-t.c.s

unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.requires:
.PHONY : unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.requires

unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.provides: unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.requires
	$(MAKE) -f unittest/mysys/CMakeFiles/my_atomic-t.dir/build.make unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.provides.build
.PHONY : unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.provides

unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.provides.build: unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o
.PHONY : unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.provides.build

# Object files for target my_atomic-t
my_atomic__t_OBJECTS = \
"CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o"

# External object files for target my_atomic-t
my_atomic__t_EXTERNAL_OBJECTS =

unittest/mysys/my_atomic-t: unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o
unittest/mysys/my_atomic-t: unittest/mytap/libmytap.a
unittest/mysys/my_atomic-t: mysys/libmysys.a
unittest/mysys/my_atomic-t: strings/libstrings.a
unittest/mysys/my_atomic-t: extlib/dbug/libdbug.a
unittest/mysys/my_atomic-t: /lib/libm.so
unittest/mysys/my_atomic-t: unittest/mysys/CMakeFiles/my_atomic-t.dir/build.make
unittest/mysys/my_atomic-t: unittest/mysys/CMakeFiles/my_atomic-t.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking C executable my_atomic-t"
	cd /tmp/bootstrap-dir.5535/source/unittest/mysys && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/my_atomic-t.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
unittest/mysys/CMakeFiles/my_atomic-t.dir/build: unittest/mysys/my_atomic-t
.PHONY : unittest/mysys/CMakeFiles/my_atomic-t.dir/build

unittest/mysys/CMakeFiles/my_atomic-t.dir/requires: unittest/mysys/CMakeFiles/my_atomic-t.dir/my_atomic-t.c.o.requires
.PHONY : unittest/mysys/CMakeFiles/my_atomic-t.dir/requires

unittest/mysys/CMakeFiles/my_atomic-t.dir/clean:
	cd /tmp/bootstrap-dir.5535/source/unittest/mysys && $(CMAKE_COMMAND) -P CMakeFiles/my_atomic-t.dir/cmake_clean.cmake
.PHONY : unittest/mysys/CMakeFiles/my_atomic-t.dir/clean

unittest/mysys/CMakeFiles/my_atomic-t.dir/depend:
	cd /tmp/bootstrap-dir.5535/source && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /tmp/bootstrap-dir.5535/source /tmp/bootstrap-dir.5535/source/unittest/mysys /tmp/bootstrap-dir.5535/source /tmp/bootstrap-dir.5535/source/unittest/mysys /tmp/bootstrap-dir.5535/source/unittest/mysys/CMakeFiles/my_atomic-t.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : unittest/mysys/CMakeFiles/my_atomic-t.dir/depend

