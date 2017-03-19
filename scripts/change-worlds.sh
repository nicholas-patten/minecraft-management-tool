#!/bin/bash

####################################
# Script to change world for sever #
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
declare -r SYMLINK_NAME="server-world"
########################################################################################################

########################################################################################################
# Check directories exist
if [ ! -d "${SERVER_WORLDS_HOME}" ]; then
  echo "No server \"${SERVER}\". Aborting"
  exit 1
elif [ ! -d "${SERVER_WORLDS_HOME}/${WORLD}" ]; then  
  echo "No world \"${WORLD}\" for server \"${SERVER}\". Aborting"
  exit 1
fi 
########################################################################################################

########################################################################################################
# Change sym-linked world folder
pushd ${SERVER_WORLDS_HOME} >> /dev/null
  echo "Changing ${SERVER} server's world to ${WORLD}"
  ln -f -T -s -v ${WORLD} ${SYMLINK_NAME}
  if [ $? -ne 0 ]; then
    echo "Creation of link failed"
    exit 1
  fi
popd >> /dev/null
########################################################################################################
echo "Changed server world symlink to ${WORLD}"
