#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$(cd $THIS_DIR/../../..; pwd)

ROSMATLAB_WS_PATH="${ROOT_DIR}/rosmatlab"
CURRENT_PATH=`pwd`

# argument parsing
PACKAGE_NAME=$1

if [ -z "$PACKAGE_NAME" ]; then
    echo "Usage: $0 package_name"
    exit -1
fi

PACKAGE_PATH=`rospack find $PACKAGE_NAME`
if [ -z "$PACKAGE_PATH" ]; then
    echo "Error: Package was not found - Aborting"
    exit -1
fi

# create rosmatlab paths
cd $ROSMATLAB_WS_PATH/src/rosmatlab
rm -Rf rosmatlab_$PACKAGE_NAME
mkdir rosmatlab_$PACKAGE_NAME
cd rosmatlab_$PACKAGE_NAME

# create package files
echo "cmake_minimum_required(VERSION 2.8.3)"           >> CMakeLists.txt
echo "project(rosmatlab_$PACKAGE_NAME)"                >> CMakeLists.txt
echo "  "                                              >> CMakeLists.txt
echo "find_package(catkin REQUIRED rosmatlab)"         >> CMakeLists.txt
echo "catkin_package("                                 >> CMakeLists.txt
echo "  CATKIN_DEPENDS rosmatlab"                      >> CMakeLists.txt
echo ") "                                              >> CMakeLists.txt
echo "  "                                              >> CMakeLists.txt
echo "include_directories(${catkin_INCLUDE_DIRS})"     >> CMakeLists.txt
echo "  "                                              >> CMakeLists.txt
echo "add_mex_messages($PACKAGE_NAME)"                 >> CMakeLists.txt

echo "<package>"                                            >> package.xml
echo "  <name>rosmatlab_$PACKAGE_NAME</name>"               >> package.xml
echo "  <version>0.1.0</version>"                           >> package.xml
echo "  <description>"                                      >> package.xml
echo "     rosmatlab_$PACKAGE_NAME makes all message types in $PACKAGE_NAME available in Matlab." >> package.xml
echo "  </description>"                                     >> package.xml
echo "  <maintainer email=\"add@email.here\"></maintainer>" >> package.xml
echo "  <author email=\"add@email.here\"></author>"         >> package.xml
echo "  <license>BSD</license>"                             >> package.xml
echo "  "                                                   >> package.xml
echo "  <buildtool_depend>catkin</buildtool_depend>"        >> package.xml
echo "  <build_depend>rosmatlab</build_depend>"             >> package.xml
echo "  <build_depend>$PACKAGE_NAME</build_depend>"         >> package.xml
echo "  <build_depend>common_msgs</build_depend>"           >> package.xml
echo "  <run_depend>rosmatlab</run_depend>"                 >> package.xml
echo "</package>"                                           >> package.xml

cd $CURRENT_PATH