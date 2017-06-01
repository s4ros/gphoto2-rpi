#!/bin/bash

# simple log generator
# it pretends the gphoto2 taking photo

LOGFILE=${1:-"aparat.log"}
> ${LOGFILE}
while [ 1 ]; do
  CONTENT="#$(( RANDOM % 1000 + 1000)) DSC_$(( RANDOM % 2000 + 1000)).NEF rd $(( RANDOM % 30000 + 10000)) KB application/x-unknown"
  echo $CONTENT | tee -a ${LOGFILE}
  sleep 3
done
