#!/bin/bash

#cd $WORKSPACE_ROOT

if [ -z $WORKSPACE_ROOT ]; then
  echo "Variable WORKSPACE_ROOT not set, make sure the workspace is set up properly!"
else
  echo "Installing onboard software..."
  
  cd $WORKSPACE_ROOT

  # Install dependencies
  rosinstall/install_scripts/install_onboard.sh --no_ws_update
  
  # Common pkgs
  wstool merge rosinstall/optional/thor_mang_ocs.rosinstall
  wstool merge rosinstall/optional/behavior_control.rosinstall
  wstool merge rosinstall/optional/thor_mang_gazebo.rosinstall
  
  # This is required because otherwise gazebo_ros_control crashes Gazebo4
  # See https://github.com/ros-simulation/gazebo_ros_pkgs/issues/341
  wstool merge rosinstall/optional/gazebo_ros_pkgs_jade.rosinstall.rosinstall
 
  # Optionally check if update is requested. Not doing update saves some
  # time when called from other scripts
  while [ -n "$1" ]; do
    case $1 in
    --no_ws_update)
        UPDATE_WORKSPACE=1
        ;;
    esac

    shift
  done
  
  if [ -n "$UPDATE_WORKSPACE" ]; then
    echo "Not updating workspace as --no_ws_update was set"    
  else 
    wstool update
    rosdep update
    rosdep install -r --from-path . --ignore-src
  fi 
  
fi
