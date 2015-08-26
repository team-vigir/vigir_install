#!/bin/bash

#cd $WORKSPACE_ROOT

if [ -z $WORKSPACE_ROOT ]
then
  echo "Variable WORKSPACE_ROOT not set, make sure the workspace is set up properly!"
else
  echo "Installing onboard software..."
  
  cd $WORKSPACE_ROOT
  wstool merge rosinstall/optional/perception.rosinstall
  wstool merge rosinstall/optional/footstep_planning.rosinstall
  wstool merge rosinstall/optional/launch.rosinstall
  wstool merge rosinstall/optional/manipulation_planning.rosinstall
  wstool merge rosinstall/optional/common_msgs.rosinstall
  wstool merge rosinstall/optional/moveit.rosinstall
  wstool merge rosinstall/optional/object_templates.rosinstall
  
fi
