#!/bin/bash

echo "Current directory is"
echo $PWD

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$(cd $THIS_DIR/../..; pwd)
cd ${ROOT_DIR}

echo "Installing SNOPT library ..."
if [ -a snopt7.2-8.zip ]
then 
  SNOPT_ARCHIVE=snopt7.2-8.zip
  echo "Extracting $SNOPT_ARCHIVE ..."
  rm -Rf snopt7
  unzip $SNOPT_ARCHIVE
  patch -p1 < rosinstall/install_scripts/helper/snopt_7.2-8.patch 
else
  echo "Enter path to SNOPT archive (where snopt7.2-8.zip is stored)"
  read
  
  SNOPT_ARCHIVE="${REPLY}/snopt7.2-8.zip"
  if [ -a $SNOPT_ARCHIVE ]
  then    
    echo "Extracting $SNOPT_ARCHIVE ..."
    rm -Rf snopt7
    unzip $SNOPT_ARCHIVE
    patch -p1 < rosinstall/install_scripts/helper/snopt_7.2-8.patch 
  else
    echo "No SNOPT archive entered. Trying to use existing directory"
  fi
fi



MATLAB_LINK=$(which matlab)

if [ -z $MATLAB_LINK ]
then
  echo "No MATLAB installation found... "
  rm -Rf snopt7/cmex
else
  # Find MATLAB path and create base dirs
  MATLAB_EXECUTABLE=$(readlink "$MATLAB_LINK")
  MATLAB_ROOT="$(dirname "$MATLAB_EXECUTABLE")/.."
  echo "Found MATLAB installation: $MATLAB_ROOT"
  export PATH=$PATH:${MATLAB_ROOT}/bin
fi

echo "Installing gfortran"
sudo apt-get install gfortran

echo "Setting up environment variables..."
SNOPT="$(pwd)/snopt7"
F2C=$SNOPT/bin
F2CLIBRARY=$SNOPT/lib
F2CINCLUDE=$SNOPT/f2c/src
export F2C F2CLIBRARY F2CINCLUDE
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SNOPT}/lib"

echo "Building snopt..."
sudo ln -s /usr/bin/make /usr/bin/gmake
cd snopt7
export F77=/usr/bin/gfortran # F77 fortran compiler setzen
./configure

MACHINE_TYPE=$(uname -m)
if [ $MACHINE_TYPE == "x86_64" ]
then
  echo "Detected 64-bit machine"
  make FFLAGS="-O2 -fPIC -fdefault-integer-8" CFLAGS="-O2 -fPIC -I${F2CINCLUDE}" CXXFLAGS="-O2 -fPIC -I${F2CINCLUDE}"
else
  echo "Did not detect x86_64 machine - assuming x86"
  make FFLAGS="-O2 -fPIC" CFLAGS="-O2 -fPIC -I${F2CINCLUDE}" CXXFLAGS="-O2 -fPIC -I${F2CINCLUDE}"
fi

echo "Installing snopt..."
#sudo make FFLAGS="-O2 -fPIC" CFLAGS="-O2 -fPIC" CXXFLAGS="-O2 -fPIC -I${F2CINCLUDE}" install
sudo cp lib/libsn* /usr/local/lib
sudo ldconfig

# setup library to be found by pkg-config
sudo cp ${ROOT_DIR}/rosinstall/install_scripts/helper/snopt_cpp.pc /usr/local/lib/pkgconfig
sudo cp ${ROOT_DIR}/rosinstall/install_scripts/helper/snopt_cpp.pc /usr/local/lib/pkgconfig/snopt_c.pc
sudo sed -i "1s|.*|prefix=${ROOT_DIR}/snopt7|" /usr/local/lib/pkgconfig/snopt_cpp.pc
sudo sed -i "1s|.*|prefix=${ROOT_DIR}/snopt7|" /usr/local/lib/pkgconfig/snopt_c.pc

# setup MATLAB paths
if [ -z $MATLAB_LINK ]
then
  echo "Setting up MATLAB paths not required"
else
  echo "Setting up MATLAB paths"
  
  if ( ! [ -a "${MATLAB_ROOT}/toolbox/local/setup_snopt_paths.m" ] ) 
  then
    echo ''                                 | sudo tee --append $MATLAB_ROOT/toolbox/local/matlabrc.m > /dev/null
    echo '% Add SNOPT paths to environment' | sudo tee --append $MATLAB_ROOT/toolbox/local/matlabrc.m > /dev/null
    echo 'setup_snopt_paths'                | sudo tee --append $MATLAB_ROOT/toolbox/local/matlabrc.m > /dev/null
  fi
  sudo cp ${ROOT_DIR}/rosinstall/install_scripts/helper/setup_snopt_paths.m $MATLAB_ROOT/toolbox/local
fi

echo "Done installing SNOPT components ..."

