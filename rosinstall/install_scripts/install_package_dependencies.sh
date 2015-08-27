#!/bin/bash

# This should be extended to first check if everything is installed and only do the sudo requiring call when there's anything missing.
echo "Installing needed packages (both ROS package and system dependency .deb packages) ..."

PACKAGES_TO_INSTALL="\
mercurial \
git \
protobuf-compiler \
libargtable2-dev \
libcoin80-dev \
libglew-dev \
libgsl0-dev \
liblapack-dev \
libsnappy-dev \
libsoqt4-dev \
libtinyxml-dev \
libunittest++-dev \
python-rosinstall \
libsdl-image1.2-dev \
libvtk-java \
python-pymodbus \
ros-$ROS_DISTRO-spacenav-node \
ros-$ROS_DISTRO-bfl \
ros-$ROS_DISTRO-cmake-modules \
ros-$ROS_DISTRO-desktop \
ros-$ROS_DISTRO-eigen-stl-containers \
ros-$ROS_DISTRO-fcl \
ros-$ROS_DISTRO-image-pipeline \
ros-$ROS_DISTRO-octomap-msgs \
ros-$ROS_DISTRO-octomap-ros \
ros-$ROS_DISTRO-octomap-rviz-plugins \
ros-$ROS_DISTRO-ompl \
ros-$ROS_DISTRO-sbpl \
ros-$ROS_DISTRO-random-numbers \
ros-$ROS_DISTRO-rosbash \
ros-$ROS_DISTRO-rosbuild \
ros-$ROS_DISTRO-rosmake \
ros-$ROS_DISTRO-rqt-robot-monitor \
ros-$ROS_DISTRO-shape-tools \
ros-$ROS_DISTRO-smach-ros \
ros-$ROS_DISTRO-stereo-image-proc \
ros-$ROS_DISTRO-depth-image-proc \
ros-$ROS_DISTRO-warehouse-ros \
ros-$ROS_DISTRO-image-transport-plugins \
ros-$ROS_DISTRO-laser-filters \
ros-$ROS_DISTRO-moveit-ros \
ros-$ROS_DISTRO-moveit-resources \
ros-$ROS_DISTRO-moveit-planners-ompl \
ros-$ROS_DISTRO-moveit-simple-controller-manager \
ros-$ROS_DISTRO-moveit-commander \
ros-$ROS_DISTRO-joy \
ros-$ROS_DISTRO-pcl-ros \
ros-$ROS_DISTRO-image-common \
ros-$ROS_DISTRO-driver-base \
ros-$ROS_DISTRO-robot-pose-ekf \
ros-$ROS_DISTRO-ros-control \
ros-$ROS_DISTRO-ros-controllers \
ros-$ROS_DISTRO-urdfdom-py \
ros-$ROS_DISTRO-map-server \
ros-$ROS_DISTRO-laser-assembler"


sudo apt-get -y install $PACKAGES_TO_INSTALL
