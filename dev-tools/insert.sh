#!/bin/bash

set -x

SERVER="localhost:56789"

LOGFILE="aparat.log"

# /usr/bin/gphoto2 -L | tail -n 50> $LOGFILE
CONTENT=$(tail -n1 ${LOGFILE})
FILENAME=$(echo $CONTENT | cut -d ' ' -f 2)
DATE=$(stat -c "%Y" ${LOGFILE})

# RPI_ID=$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)
RPI_ID=${1-"1234"}

curl -H "Content-Type: application/json" \
  -X POST \
  -d "{\"date\":${DATE},\"content\": \"${CONTENT}\",\"filename\":\"${FILENAME}\",\"rpi_id\":\"${RPI_ID:-0x0000}\"}" \
  http://${SERVER}/insert
