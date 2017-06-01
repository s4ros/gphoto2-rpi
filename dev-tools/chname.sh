#!/bin/bash
# set -x
id=$1
name=$2
SERVER=${3:-'localhost:56789'}

curl -X POST \
  -H "Content-Type: application/json" \
  -d "{\"id\":${id}, \"name\":\"${2}\"}" \
  http://${SERVER:-"localhost:56789"}/chname
