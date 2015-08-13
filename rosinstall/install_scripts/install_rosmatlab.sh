#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(cd $THIS_DIR/../..; pwd)
cd ${BASE_DIR}

echo "Base directory is"
echo $BASE_DIR

echo "Installing TUD rosmatlab package ..."
MATLAB_LINK=$(which matlab)

if [ -z "$MATLAB_LINK" ]
then
  echo "No MATLAB installation found... Please install MATLAB first"
  exit -1
else  
  # Find MATLAB path and create base dirs
  MATLAB_EXECUTABLE=$(readlink "$MATLAB_LINK")
  MATLAB_ROOT="$(dirname "$MATLAB_EXECUTABLE")/.."
  MATLAB_ROOT=$(readlink -f $MATLAB_ROOT)
  echo "Found MATLAB installation: $MATLAB_ROOT"
  
  cd ${MATLAB_ROOT}
  sudo rm -rf ros
  sudo mkdir -p ros/indigo
  sudo chown $USER ros/indigo
  
  # Find MATLAB boost version, download and build
  echo "Building corresponding boost version ..."
  BOOST_LIB_NAME=$(ls -1 ${MATLAB_ROOT}/bin/*/libboost_*.so* | tail -n 1)
  BOOST_LIB_ARRAY=(${BOOST_LIB_NAME//./ })
  BOOST_LIB_ARRAY_LENGTH=${#BOOST_LIB_ARRAY[@]}
  BOOST_VERSION_MAJOR=${BOOST_LIB_ARRAY[${BOOST_LIB_ARRAY_LENGTH}-3]}
  BOOST_VERSION_MINOR=${BOOST_LIB_ARRAY[${BOOST_LIB_ARRAY_LENGTH}-2]}
  BOOST_VERSION_REVISION=${BOOST_LIB_ARRAY[${BOOST_LIB_ARRAY_LENGTH}-1]}
  echo "Downloading Boost version $BOOST_VERSION_MAJOR.$BOOST_VERSION_MINOR.$BOOST_VERSION_REVISION ..."
  
  cd `mktemp -d`
  wget "http://downloads.sourceforge.net/project/boost/boost/$BOOST_VERSION_MAJOR.$BOOST_VERSION_MINOR.$BOOST_VERSION_REVISION/boost_${BOOST_VERSION_MAJOR}_${BOOST_VERSION_MINOR}_${BOOST_VERSION_REVISION}.tar.bz2"
  tar xjf boost_${BOOST_VERSION_MAJOR}_${BOOST_VERSION_MINOR}_${BOOST_VERSION_REVISION}.tar.bz2
    
  cd boost_${BOOST_VERSION_MAJOR}_${BOOST_VERSION_MINOR}_${BOOST_VERSION_REVISION}
  
  if [ "$BOOST_VERSION_MAJOR.$BOOST_VERSION_MINOR.$BOOST_VERSION_REVISION" == "1.49.0" ]
  then 
    echo "This Boost version needs patching..."
    patch -p1 < ${BASE_DIR}/rosinstall/install_scripts/helper/boost_1_49_0_xtime.patch
  fi
  
  echo "Ready to build ..."
  ./bootstrap.sh --prefix=${MATLAB_ROOT}/ros/indigo
  ./bjam variant=release link=shared threading=multi install
  export BOOST_ROOT=$MATLAB_ROOT/ros/indigo
  
  echo "Boost installation finished"
  
  # install rosinstall_generator
  echo "Installing rosinstall_generator"
  sudo apt-get install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
  echo "rosinstall_generator installation done"
  
  # install ROS for MATLAB (start with clean environment to ignore existing ROS installation 
  env -i ${BASE_DIR}/rosinstall/install_scripts/helper/install_rosmatlab_helper.sh ${MATLAB_ROOT} ${BASE_DIR}
  
  # add MATLAB root to .bashrc
  echo "export MATLAB_ROOT=$MATLAB_ROOT" >> $HOME/.bashrc
  
  cd $BASE_DIR
fi

echo "Done installing rosmatlab components ...!"

