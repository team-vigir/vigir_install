#!/bin/bash

# path configuration
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$(cd $THIS_DIR/../../..; pwd)
ROSMATLAB_WS_PATH="$ROOT_DIR/rosmatlab" # path to your rosmatlab workspace

MATLAB_LINK=$(which matlab)
if [ -z "$MATLAB_LINK" ]
then
  echo "No MATLAB installation found... Please install MATLAB and rosmatlab first"
  exit -1
fi

# Find MATLAB path and create base dirs
MATLAB_EXECUTABLE=$(readlink "$MATLAB_LINK")
MATLAB_ROOT="$(dirname "$MATLAB_EXECUTABLE")/.."
ROSMATLAB_PATH="$MATLAB_ROOT/ros/indigo"        # the path to your rosmatlab installation

echo "Using the following paths, please check carefully"
echo "ROOT_DIR:          $ROOT_DIR"
echo "ROSMATLAB_WS_PATH: $ROSMATLAB_WS_PATH"
echo "ROSMATLAB_PATH:    $ROSMATLAB_PATH"

# argument parsing
CURRENT_PATH=`pwd`

# loop through all packages and copy relevant data
cd $ROSMATLAB_WS_PATH/src/rosmatlab
for PACKAGE_NAME in `ls -1d rosmatlab_*`; 
do
  PACKAGE_NAME=${PACKAGE_NAME#*_}
  
  if ( [ $PACKAGE_NAME == "common_msgs" ] || [ $PACKAGE_NAME == "rosbag" ] ) # rosmatlab default package
  then
    continue
  fi
    
  echo "Updating package: $PACKAGE_NAME"
  
  PACKAGE_PATH=`rospack find $PACKAGE_NAME`
  if [ -z "$PACKAGE_PATH" ]; then
      echo "Error: Package was not found - Aborting"
      exit -1
  fi

  if [[ ${PACKAGE_PATH} == *"${ROOT_DIR}"* ]] # it's a THOR or ATLAS package
  then  
    if [ -a "${ROOT_DIR}/devel" ]; then # THOR
      DEVEL_PATH="${ROOT_DIR}/devel" # the devel path of your current catkin workspace 
    elif [ -a "${ROOT_DIR}/catkin_ws/devel" ]; then # ATLAS
      DEVEL_PATH="${ROOT_DIR}/catkin_ws/devel" # the devel path of your current catkin workspace 
    else
      echo "Not matching DEVEL_PATH found - Aborting."
      continue;
    fi

  else  
    DEVEL_PATH="$ROS_ROOT/../.." # the devel path of your current catkin workspace 
    #echo "Package is part of global ROS installation: $DEVEL_PATH"
  fi
  
  # cleanup old stuff
  rm -Rf $ROSMATLAB_PATH/share/$PACKAGE_NAME
  rm -Rf $ROSMATLAB_PATH/include/$PACKAGE_NAME
  rm -Rf $ROSMATLAB_PATH/include/introspection/$PACKAGE_NAME

  # copy stuff from current package
  mkdir $ROSMATLAB_PATH/share/$PACKAGE_NAME
  cp -R $DEVEL_PATH/share/$PACKAGE_NAME/msg $ROSMATLAB_PATH/share/$PACKAGE_NAME
  cp -R ${PACKAGE_PATH}/msg $ROSMATLAB_PATH/share/$PACKAGE_NAME
  cp $PACKAGE_PATH/package.xml $ROSMATLAB_PATH/share/$PACKAGE_NAME/package.xml
  cp -R $DEVEL_PATH/share/$PACKAGE_NAME/cmake $ROSMATLAB_PATH/share/$PACKAGE_NAME

  cp -R $DEVEL_PATH/include/$PACKAGE_NAME $ROSMATLAB_PATH/include
done

echo "Ready to build rosmatlab packages..."
echo "Press any key to continue"
read

# build packages
cd $ROSMATLAB_WS_PATH

# install ROS for MATLAB (start with clean environment to ignore existing ROS installation 
env -i ${ROOT_DIR}/rosinstall/install_scripts/helper/update_rosmatlab_msgs_helper.sh $ROSMATLAB_PATH

cd $CURRENT_PATH
