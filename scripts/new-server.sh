#!/bin/bash

###############################
# Script to create new server #
###############################

########################################################################################################
# Check arguments and Linux environment is set up
if [ ${#} -ne 1 ]; then
  echo "Usage ${0} <server>"
  exit 1
fi

if [ -z ${SERVERS_HOME} ] || [ ! -e "${SERVERS_HOME}" ]; then
  echo "No Servers Home set. Aborting"
  exit 1
elif [ -z ${SERVER_ARTIFACTS_DIR} ] || [ ! -e "${SERVER_ARTIFACTS_DIR}" ]; then
  echo "No Servers artifact directory set. Aborting"
  exit 1
fi

declare -r SERVER=${1}
declare -r SERVER_HOME=${SERVERS_HOME}/${SERVER}
declare -r WORLD="first-world"
declare -r SYMLINK_NAME="server-world"
########################################################################################################

########################################################################################################
# Check directories exist
if [ ! -d "${SERVERS_HOME}" ]; then
  echo "No servers home directory. Aborting"
  exit 1
elif [ ! -d "${SERVER_ARTIFACTS_DIR}" ]; then
  echo "No server artifacts directory. Aborting"
  exit 1
elif [ -d "${SERVER_HOME}" ]; then
  echo "Server \"${SERVER}\" already exists. Aborting"
  exit 1
fi

pushd ${SERVERS_HOME} >> /dev/null
  echo "Creating new server: ${SERVER}"
  mkdir ${SERVER}
  if [ ${?} -ne 0 ]; then
    echo "Creation of directory failed"
    exit 1
  fi
   
  pushd ${SERVER} >> /dev/null
   wget https://s3.amazonaws.com/Minecraft.Download/versions/${SERVER}/minecraft_server.${SERVER}.jar
   if [ ${?} -ne 0 ]; then 
     echo "Failed to download jar for server: ${SERVER}"
   fi
   
   pushd ${WORLDS_HOME} >> /dev/null
    echo "Creating new world for ${SERVER}, ${WORLD}"
    mkdir -p ${SERVER}/${WORLD}
    if [ $? -ne 0 ]; then
      echo "Creation of world directory failed"
      exit 1
    fi
   
    pushd ${SERVER} >> /dev/null
      echo "Setting ${SERVER} server's world to ${WORLD}"
      ln -f -T -s -v ${WORLD} ${SYMLINK_NAME}
      if [ $? -ne 0 ]; then
        echo "Creation of link failed"
        exit 1
      fi
    popd >> /dev/null
   popd >> /dev/null
   echo "Created server world: ${WORLD}"

   echo "Creating ${SERVER} server's symlink to world: ${WORLD}"
   ln -f -T -s -v ${WORLDS_HOME}/${SERVER}/${SYMLINK_NAME} world
   if [ $? -ne 0 ]; then
     echo "Creation of link failed"
     exit 1
   fi

   cp -Rp ${SERVER_ARTIFACTS_DIR}/* .
   if [ ! -f "start-server.sh" ]; then
     echo "No start script for server: ${SERVER}. Aborting"
     exit 1 
   fi  
 
   chmod u+x *.sh
   bash start-server.sh
   sed -i 's/eula=false/eula=true/' eula.txt
   bash start-server.sh
  popd >> /dev/null
popd >> /dev/null
echo "Created server: ${SERVER}"
