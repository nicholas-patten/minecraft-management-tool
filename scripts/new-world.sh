#!/bin/bash

####################################
# Script to create world for sever #
####################################

########################################################################################################
# Check arguments and Linux environment is set up
if [ ! $# -eq 2 ]; then
  echo "Usage ${0} <server> <world>"
  exit 1
fi

if [ -z ${WORLDS_HOME} ] || [ ! -e "${WORLDS_HOME}" ]; then
  "No World Home set. Aborting"
  exit 1
fi

declare -r SERVER=${1} 
declare -r WORLD=${2}
declare -r SERVER_WORLDS_HOME=${WORLDS_HOME}/${SERVER}
########################################################################################################

########################################################################################################
# Check directories exist
if [ ! -d "${SERVER_WORLDS_HOME}" ]; then
  echo "No worlds folder for server: \"${SERVER}\". Aborting"
  exit 1
elif [ -d "${SERVER_WORLDS_HOME}/${WORLD}" ]; then  
  echo "World \"${WORLD}\" already exists for server \"${SERVER}\". Aborting"
  exit 1
fi 

pushd ${SERVER_WORLDS_HOME} >> /dev/null
  echo "Creating new world for ${SERVER}, ${WORLD}"
  mkdir ${WORLD}
  if [ $? -ne 0 ]; then
    echo "Creation of directory failed"
    exit 1
  fi
popd >> /dev/null
echo "Created server world: ${WORLD}"
########################################################################################################

########################################################################################################
# Change server world symlink to new world
change-worlds ${SERVER} ${WORLD}
if [ ${?} -ne 0 ]; then
 echo "Failed to symlink ${WORLD} as server world. Aborting"
 exit 1
fi
########################################################################################################
