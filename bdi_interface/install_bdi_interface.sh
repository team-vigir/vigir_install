#!/bin/bash

echo "Current directory is"
echo $PWD


    echo "Add atlas specific components to catkin development environment ..."
    #cd catkin_ws/src/
    #wstool merge ../../rosinstall/vigir_atlas_catkin.rosinstall
    #wstool update

    #rosdep update

    export ATLAS_ROBOT_INTERFACE=$PWD/AtlasRobotInterface_3.0.0
    export ATLAS_SIMULATION_INTERFACE=$PWD/AtlasSimInterface_3.0.2
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ATLAS_ROBOT_INTERFACE/lib64

    echo "Set ATLAS_ROBOT_INTERFACE to point to $ATLAS_ROBOT_INTERFACE"
    echo "Set ATLAS_SIMULATION_INTERFACE to point to $ATLAS_SIMULATION_INTERFACE"

    #echo "Add atlas specific components to rosbuild development environment ..."
    #cd ../../rosbuild_ws
    #wstool merge ../rosinstall/vigir_atlas_rosbuild.rosinstall
    #wstool update

    #rosdep update

    echo "-------------------------------"
    cd ${ATLAS_SIMULATION_INTERFACE}/lib64
    echo "Copy the BDI Atlas simulation interface in "$PWD
    echo "     to /opt/ros/indigo/lib/libAtlasSimInterface3.so.3.0.2 ..."
    sudo cp libAtlasSimInterface.so.3.0.2 /opt/ros/indigo/lib/libAtlasSimInterface3.so.3.0.2

    echo "Done installing BDI interface specific components ... ready to build!"



