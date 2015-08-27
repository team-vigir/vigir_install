#!/bin/bash

#cd $WORKSPACE_ROOT

if [ -z $WORKSPACE_ROOT ]; then
  echo "Variable WORKSPACE_ROOT not set, make sure the workspace is set up properly!"
else
  echo "Installing onboard software..."
  
  cd $WORKSPACE_ROOT
  
  # Common pkgs
  wstool merge rosinstall/optional/common_msgs.rosinstall
  wstool merge rosinstall/optional/utilities.rosinstall
  wstool merge rosinstall/optional/launch.rosinstall
  
  # Manipulation planning
  wstool merge rosinstall/optional/moveit.rosinstall
  wstool merge rosinstall/optional/manipulation_planning.rosinstall  
  wstool merge rosinstall/optional/object_templates.rosinstall
    
  # Perception, footstep planning
  wstool merge rosinstall/optional/perception.rosinstall
  wstool merge rosinstall/optional/footstep_planning.rosinstall  
 
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
