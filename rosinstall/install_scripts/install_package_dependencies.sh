#!/bin/bash

# This should be extended to first check if everything is installed and only do the sudo requiring call when there's anything missing.
echo "Installing needed packages (both ROS package and system dependency .deb packages) ..."

PACKAGES_TO_INSTALL="\
mercurial \
git \
python-rosdep \
python-wstool \
python-catkin-tools \
ros-$ROS_DISTRO-desktop \
ros-$ROS_DISTRO-serial \
ros-$ROS_DISTRO-hector-slam \
ros-$ROS_DISTRO-hector-localization \
ros-$ROS_DISTRO-map-server
ros-$ROS_DISTRO-fcl \
ros-$ROS_DISTRO-image-pipeline \
ros-$ROS_DISTRO-octomap-msgs \
ros-$ROS_DISTRO-octomap-ros \
ros-$ROS_DISTRO-octomap-rviz-plugins \
ros-$ROS_DISTRO-ompl \
ros-$ROS_DISTRO-sbpl \
ros-$ROS_DISTRO-moveit-ros \
ros-$ROS_DISTRO-moveit-resources \
ros-$ROS_DISTRO-moveit-planners-ompl \
ros-$ROS_DISTRO-moveit-simple-controller-manager \
ros-$ROS_DISTRO-ros-control \
ros-$ROS_DISTRO-ros-controllers \
ros-$ROS_DISTRO-camera-info-manager \
ros-$ROS_DISTRO-moveit-commander \
ros-$ROS_DISTRO-urdfdom-py \
ros-$ROS_DISTRO-urg-node \
ros-$ROS_DISTRO-keyboard \
ros-$ROS_DISTRO-joy \
ros-$ROS_DISTRO-laser-filters \
ros-$ROS_DISTRO-pcl-ros"

sudo apt-get -y install $PACKAGES_TO_INSTALL
