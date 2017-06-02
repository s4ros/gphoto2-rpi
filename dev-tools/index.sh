#!/bin/bash

SERVER=${1:-"localhost:56789"}

curl -X GET \
  http://${SERVER}/
echo
