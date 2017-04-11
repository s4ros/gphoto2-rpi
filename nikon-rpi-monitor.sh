#!/bin/bash

set -x

LOGFILE=/tmp/aparat.log

/usr/bin/gphoto2 -L > $LOGFILE
CONTENT=$(tail -n1 ${LOGFILE})
FILENAME=$(echo $CONTENT | cut -d ' ' -f 2)
DATE=$(stat -c "%Y" ${LOGFILE})

curl -H "Content-Type: application/json" \
  -X POST \
  -d "{\"date\":${DATE},\"content\": \"${CONTENT}\",\"filename\":\"${FILENAME}\"}" \
  http://infinigy.pl:56789/insert
