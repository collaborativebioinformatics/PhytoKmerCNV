#!/bin/sh

#
# Installs the Mambaforge conda distribution and adds the specified project environment.
#

CONDA_PREFIX=~/miniconda3
ENV_FILE=environment.yml
REPO_DIR=`pwd`

cd /tmp/
curl -LO https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash Mambaforge-Linux-x86_64.sh -b -u -p $CONDA_PREFIX
cd $REPO_DIR

$CONDA_PREFIX/bin/mamba env create --file $ENV_FILE
