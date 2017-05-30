#!/bin/bash

SERVER="localhost:56789"

curl -X GET \
  http://${SERVER}/dbinit
echo ""
