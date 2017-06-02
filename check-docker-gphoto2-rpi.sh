#!/bin/bash

##############################################################################
## Simple "watchdog" script which can be put into cron
## to ensure that container is up and running
##############################################################################
# path to directory where to mount docker volume
RPI_PATH=${1:-/opt/home/s4ros/gphoto2-rpi}
SERVER=${2:-localhost:56789}

function reset-gphoto2-container()
{
  docker stop gphoto2-rpi || docker kill gphoto2-rpi
  docker rm gphoto2-rpi
  docker run -d --name gphoto2-rpi -v ${RPI_PATH}:/rpi -v /etc/localtime:/etc/localtime:ro -p 127.0.0.1:56789:56789 s4ros/gphoto2-rpi
}

if [[ "$1" == "restart" ]]; then
  reset-gphoto2-container
  exit 0
fi

if [[ $(docker ps | grep 56789 | wc -l) -ne 1 ]]; then
  reset-gphoto2-container
fi

curl -s --connect-timeout 15 http://${SERVER}/ &> /dev/null
if [[ $? -ne 0 ]]; then
  reset-gphoto2-container
fi
