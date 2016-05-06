#!/bin/bash

# Check anaconda and Python versions
CONDA_PATH=`which conda`
if [ "x$?" != "x0" ]; then
    echo "conda is not in the PATH!"
    exit 1
fi

# JupyterHub requires Python >= 3.3
# To run the single-user servers we need jupyter notebook >= 4
python --version 2>&1 | grep "Python 3\.[^012]" || { echo "You need Python >= 3.3."; exit 1; }

# Install JupyterHub
pip install jupyterhub

# Install bash and octave kernels
pip install bash_kernel octave_kernel
python -m bash_kernel.install
python -m octave_kernel.install

# Install Python 2.x kernel
source activate py27
ipython kernel install
