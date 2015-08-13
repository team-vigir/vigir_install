#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$(cd $THIS_DIR/../..; pwd)

echo "ROOT_DIR = ${ROOT_DIR}"

echo ""
echo "============================"
echo "Installing ROSMATLAB package"
echo "============================"
${ROOT_DIR}/rosinstall/install_scripts/install_rosmatlab.sh

echo ""
echo "============================"
echo "Installing ROSMATLAB messages"
echo "============================"
${ROOT_DIR}/rosinstall/install_scripts/helper/add_rosmatlab_msgs.sh moveit_msgs
${ROOT_DIR}/rosinstall/install_scripts/helper/add_rosmatlab_msgs.sh octomap_msgs
${ROOT_DIR}/rosinstall/install_scripts/helper/add_rosmatlab_msgs.sh object_recognition_msgs
${ROOT_DIR}/rosinstall/install_scripts/helper/add_rosmatlab_msgs.sh vigir_planning_msgs
${ROOT_DIR}/rosinstall/install_scripts/helper/update_rosmatlab_msgs.sh

echo ""
echo "============================"
echo "Installing SNOPT"
echo "============================"
${ROOT_DIR}/rosinstall/install_scripts/install_snopt.sh

echo ""
echo "============================"
echo "Installing Drake"
echo "============================"
${ROOT_DIR}/rosinstall/install_scripts/install_drake.sh


echo "Done installing Drake components ..."
echo "Restart terminal or source .bashrc to update environment before running."

