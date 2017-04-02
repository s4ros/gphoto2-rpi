#!/bin/bash

##############################################################################
## Simple "watchdog" script which can be put into cron
## to ensure that container is up and running
##############################################################################


function reset_nikon_container()
{
  docker stop nikon-rpi || docker kill nikon-rpi
  docker rm nikon-rpi
  docker run -d --name nikon-rpi -v /opt/home/s4ros/nikon-rpi:/rpi -v /etc/localtime:/etc/localtime:ro -p 56789:56789 s4ros/nikon-rpi
}

if [[ "$1" == "restart" ]]; then
  reset_nikon_container
  exit 0
fi

if [[ $(docker ps | grep 56789 | wc -l) -ne 1 ]]; then
  reset_nikon_container
fi

curl -s --connect-timeout 15 http://infinigy.pl:56789/ &> /dev/null
if [[ $? -ne 0 ]]; then
  reset_nikon_container
fi