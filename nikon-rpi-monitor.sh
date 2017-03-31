#!/bin/bash

set -x

LOGFILE=/tmp/aparat.log
CONTENT=$(tail -n1 ${LOGFILE})
FILENAME=$(echo $CONTENT | cut -d '/' -f 5 | cut -d ' ' -f 1)
DATE=$(stat -c "%Y" ${LOGFILE})

curl -H "Content-Type: application/json" \
  -X POST \
  -d "{\"date\":${DATE},\"content\": \"${CONTENT}\",\"filename\":\"${FILENAME}\"}" \
  http://infinigy.pl:56789/input
