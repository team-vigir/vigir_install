#!/bin/bash

# get parameters from parent script
MATLAB_ROOT=$1
BASE_DIR=$2

# install ROS
echo "Installing ROS for MATLAB ..."
export PATH
cd ${MATLAB_ROOT}/ros/indigo
rm -Rf src
wstool init src
rosinstall_generator --deps --rosdistro indigo ros_comm common_msgs geometry | wstool merge -t src -
wstool update -t src
patch src/ros_comm/rosbag/src/recorder.cpp < ${BASE_DIR}/rosinstall/install_scripts/helper/rosmatlab_recorder_xtime.patch  
./src/catkin/bin/catkin_make_isolated --install --install-space ${MATLAB_ROOT}/ros/indigo -DBoost_NO_SYSTEM_PATHS=ON -DBOOST_ROOT=${MATLAB_ROOT}/ros/indigo
touch src/CATKIN_IGNORE
source $MATLAB_ROOT/ros/indigo/setup.bash
echo "ROS installation finished"
  
# install actual rosmatlab package
echo "Installing rosmatlab package"
cd $BASE_DIR
rm -Rf rosmatlab
mkdir rosmatlab
cd rosmatlab
wstool init src
wstool set -t src -y cpp_introspection --git http://github.com/tu-darmstadt-ros-pkg/cpp_introspection.git
wstool set -t src -y rosmatlab --git http://github.com/tu-darmstadt-ros-pkg/rosmatlab.git
wstool update -t src
cd src/rosmatlab
git checkout -t origin/indigo-devel
cd ../..
catkin_make -DCMAKE_INSTALL_PREFIX=$MATLAB_ROOT/ros/indigo -DBoost_NO_SYSTEM_PATHS=ON -DBOOST_ROOT=$MATLAB_ROOT/ros/indigo install
echo "rosmatlab installation finished"