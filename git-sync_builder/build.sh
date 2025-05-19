#!/bin/bash

### GLOBAL VARIABLES ###########################
REPOSITORY="https://github.com/kubernetes/git-sync"
VERSION=$1

### FUNCTIONS ##################################
Help()
{
   # Display Help
   echo 
   echo "Build a docker image of git-sync, providing the version to build."
   echo "The repository used for the build is :"
   echo "$REPOSITORY"
   echo
   echo "Please note that sudo, go, docker, git and docker-buildx are required"
   echo
   echo "Syntax: $0 <version>"
   echo
   echo "<version> must be an existing TAG in the git-sync git repository"
   echo 
}

### SCRIPT LOGIC ################################

# Display help if needed
if [[ ($# -lt 1) || $1 == "help" ]] ; then
    Help
    exit 2
fi

# check for docker
if [ ! -x "$(command -v docker)" ]; then
    echo "ERROR: docker not found"; 
fi

# check for git
if [ ! -x "$(command -v git)" ]; then
    echo "ERROR: git not found"; 
fi

# check for git
if [ ! -x "$(command -v go)" ]; then
    echo "ERROR: go not found"; 
fi

# check for git
if [ ! -x "$(command -v sudo)" ]; then
    echo "ERROR: go not found"; 
fi

# clean-up if necessary
if [ -d git-sync ]; then
    echo "removing existing git-sync directory...";
    rm -Rf git-sync
fi

echo "cloning version $VERSION..."
git clone --depth 1 --branch $VERSION $REPOSITORY

echo "building container..."
cd git-sync
sudo make container VERSION=$VERSION