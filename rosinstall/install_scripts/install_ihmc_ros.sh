#!/bin/bash

#cd $WORKSPACE_ROOT

if [ -z $WORKSPACE_ROOT ]; then
  echo "Variable WORKSPACE_ROOT not set, make sure the workspace is set up properly!"
else

  echo "--------------------------------------------------"  
  echo "Installing drcsim-prerelease as it is required for ihmc gazebo integration"
  echo "--------------------------------------------------" 
  
  sudo apt-get install drcsim-prerelease

  echo "Installing IMHC software..."
  
  cd $WORKSPACE_ROOT
  
  wstool merge rosinstall/optional/ihmc_sim_setup.rosinstall
 
  wstool update
  rosdep update
  rosdep install -r --from-path . --ignore-src
  
  echo "--------------------------------------------------"  
  echo "Retrieving IHMC binary distribution..."
  echo "--------------------------------------------------"  
  
  # Jumping through some hoops to have ihmc_atlas properly show up in
  # ROS_PACKAGE_PATH during first install. Have to build a package to
  # update ROS_PACKAGE_PATH and then source workspace setup.
  catkin build vigir_scripts
  source $WORKSPACE_ROOT/devel/setup.bash
  
  roscd ihmc_atlas
  ./scripts/ihmc_dist_update.py
  
  echo "To allow use with drcsim, follow the instructions for changing launch file here:"
  echo "https://bitbucket.org/ihmcrobotics/ihmc_ros/issues/51/ihmc-controller-causes-jumps-back-in-time"
  echo "--------------------------------------------------"  
  echo "roscd drcsim_gazebo"
  echo "sudo nano launch/atlas_no_controllers.launch"
  
fi
