#!/bin/bash

echo "Current directory is"
echo $PWD

echo "Install Drake distribution and dependencies ..."

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$(cd $THIS_DIR/../..; pwd)
cd ${ROOT_DIR}

MATLAB_LINK=$(which matlab)

if [ -z $MATLAB_LINK ]
then
  echo "No MATLAB installation found..."
else
  # Find MATLAB path and create base dirs
  MATLAB_EXECUTABLE=$(readlink "$MATLAB_LINK")
  MATLAB_ROOT="$(dirname "$MATLAB_EXECUTABLE")/.."
  MATLAB_ROOT=$(readlink -f $MATLAB_ROOT)
  echo "Found MATLAB installation: $MATLAB_ROOT"
fi



echo "Cloning Drake repositories ..."
rm -Rf drake-distro
git clone https://github.com/RobotLocomotion/drake-distro.git --recursive -b rigidbody
cd drake-distro/drake
git pull origin master --recurse-submodules
git submodule update --recursive
cd ..

echo "Installing dependencies ..."
sudo apt-get update
sudo ./install_prereqs.sh ubuntu

echo "Building Drake distro"
patch drake/solvers/NonlinearProgramSnoptmex.cpp < ${ROOT_DIR}/rosinstall/install_scripts/helper/drake_snopt.patch
BUILD_PREFIX="`pwd`/build" make
unset BUILD_PREFIX
cd ..

if [ -z ${MATLAB_ROOT} ] 
then
  echo "Setting up MATLAB paths not required"
else
  echo "Setting up MATLAB paths"
  if ( ! [ -a "${MATLAB_ROOT}/toolbox/local/setup_drake_paths.m" ] ) 
  then
    echo ''                                 | sudo tee --append $MATLAB_ROOT/toolbox/local/matlabrc.m > /dev/null
    echo '% Add drake paths to environment' | sudo tee --append $MATLAB_ROOT/toolbox/local/matlabrc.m > /dev/null
    echo 'setup_drake_paths'                | sudo tee --append $MATLAB_ROOT/toolbox/local/matlabrc.m > /dev/null
  fi
  sudo cp ${ROOT_DIR}/rosinstall/install_scripts/helper/setup_drake_paths.m $MATLAB_ROOT/toolbox/local
fi

echo "Done installing Drake components ...!"

