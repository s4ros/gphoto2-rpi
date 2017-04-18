#!/bin/bash

pidof autossh
if [[ $? -ne 0 ]]; then
  killall -9 autossh
  /usr/bin/autossh -M 0 -N -f -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -i /home/pi/.ssh/id_rsa -R 56660:localhost:22 tunel@infinigy.pl
fi
