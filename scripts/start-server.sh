#!/bin/bash

##########################
# Script to start server #
##########################

########################################################################################################
# Check arguments and Linux environment is set up
if [ ${#} -ne 1 ]; then
   echo "Usage ${0} <server>"
   exit 1
fi

echo "[INFO] Checking SERVERS_HOME is set"
if [ -z ${SERVERS_HOME} ] || [ ! -e "${SERVERS_HOME}" ]; then
  echo "[ERROR] No Servers Home set. Aborting"
  exit 1
fi

declare -r SERVER=${1}
declare -r SERVER_HOME=${SERVERS_HOME}/${SERVER}
########################################################################################################

########################################################################################################
# Check directories exist
echo "[INFO] Checking server directories exist"
if [ ! -d "${SERVERS_HOME}" ]; then
  echo "[ERROR] No servers home directory. Aborting"
  exit 1
elif [ ! -d "${SERVER_HOME}" ]; then
  echo "[ERROR] No directory for server: \"${SERVER}\". Aborting"
  exit 1
fi
########################################################################################################

########################################################################################################
# Start server
pushd ${SERVER_HOME} >> /dev/null
  declare -r START_SCRIPT="start-server.sh"

  echo "[INFO] Checking ${START_SCRIPT} exists"
  if [ ! -f "${START_SCRIPT}" ]; then
    echo "[ERROR] No ${START_SCRIPT} script for server. Aborting" 
    exit 1
  fi
  
  echo "[INFO] Giving ${START_SCRIPT} run permissions, if required" 
  chmod u+x ${START_SCRIPT}
  if [ ${?} -ne 0 ]; then
    echo "[ERROR] Failed to set run permissions on ${START_SCRIPT} script. Aborting"
    exit 1
  fi
  
  echo "[INFO] Starting screen session for minecraft ${SERVER} and running ${START_SCRIPT}"
  screen -S 'minecraft' -d -m bash ${START_SCRIPT}
  if [ ${?} -ne 0 ]; then 
    echo "[ERROR] Failed to start minecraft screen session for server ${SERVER}. Aborting"
    exit 1
  fi
  echo "[INFO] Started screen session for minecraft ${SERVER}"
popd >> /dev/null
########################################################################################################
