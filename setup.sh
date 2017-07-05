#!/bin/bash

set -e

# PLEASE, provide at least the RPORT

RPORT=${1:-56661}
SERVER=${2:-"localhost:56789"}

echo "--- Importing variables from setup-vars file"
source setup-vars

usage()
{
  echo -e "\nUsage: ${0} <RPORT> [SERVER]"
  echo ""
  echo "<RPORT> - port to be opened on remote host (server) for accessing this device (raspberry)"
  echo "[SERVER] - rpi-server address to connect to: rpi.s4ros.it"
  exit 1
}

if [[ -z $1 ]]; then
  echo "Please, provide at least RPORT"
  usage
  exit 1
fi

# packages installation
echo "--- Installing packages"
sudo apt-get update -q
sudo apt-get upgrade -q -y
sudo apt-get install -q -y vim gphoto2 autossh git

# setup reverse shell connection
echo "--- Setup reverse shell connection"
mkdir -p $(dirname $REVERSE_PATH)
echo $REVERSE_SETUP | base64 -d > $REVERSE_PATH
chmod +x $REVERSE_PATH
mkdir -p ${PI_HOME}/.ssh
echo ${RSA_SETUP} | base64 -d > ${PI_HOME}/.ssh/id_rsa
chmod 600 ${PI_HOME}/.ssh/id_rsa

# setup gphoto2 cron job
echo "--- Setup gphoto2 cron job"
echo "  - RPORT = $RPORT"
echo "  - SERVER = $SERVER"
sudo bash -c "echo ${CRON_SETUP} | base64 -d > ${CRON_PATH}"
sudo sed -i "s/--RPORT--/${RPORT}/" $CRON_PATH
sudo sed -i "s/--SERVER--/${SERVER}/" $CRON_PATH

# clone git repo
echo "--- Clone git gphoto2-rpi repo from Github"
git clone ${REPO_URL} ${PI_HOME}/gphoto2-rpi > /dev/null
chmod +x ${PI_HOME}/gphoto2-rpi/gphoto2-rpi-monitor.sh
