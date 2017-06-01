#!/bin/bash

set -x

SERVER=${1:-"rpi.s4ros.it"}

LOGFILE=${2:-"/tmp/aparat.log"}

/usr/bin/gphoto2 -L > $LOGFILE
CONTENT=$(tail -n1 ${LOGFILE})
FILENAME=$(echo $CONTENT | cut -d ' ' -f 2)
DATE=$(stat -c "%Y" ${LOGFILE})

RPI_ID=$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)

curl -H "Content-Type: application/json" \
  -X POST \
  -d "{\"date\":${DATE},\"content\": \"${CONTENT}\",\"filename\":\"${FILENAME}\",\"rpi_id\":\"${RPI_ID:-0x0000}\"}" \
  http://${SERVER}/insert
