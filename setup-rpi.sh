#!/bin/bash

set -e

CRON_SETUP='MCwxMCwyMCwzMCw0MCw1MCAqICogKiAqIHBpIC91c3IvYmluL2dwaG90bzIgLS1zZXQtY29uZmlnIGNhcHR1cmV0YXJnZXQ9MTsgL3Vzci9iaW4vZ3Bob3RvMiAtLWNhcHR1cmUtaW1hZ2UKMiwxMiwyMiwzMiw0Miw1MiAqICogKiAqIHBpIC9ob21lL3BpL25pa29uLXJwaS9uaWtvbi1ycGktbW9uaXRvci5zaCAmPiAvZGV2L251bGwKKiAqICogKiAqICAgICAgICAgICAgICAgIHBpIC9ob21lL3BpL2Jpbi9yZXZlcnNlCg=='
CRON_PATH=/etc/cron.d/camera

REVERSE_SETUP='IyEvYmluL2Jhc2gKClJQT1JUPTU2NjYwCgpwaWRvZiBhdXRvc3NoCmlmIFtbICQ/IC1uZSAwIF1dOyB0aGVuCiAga2lsbGFsbCAtOSBhdXRvc3NoCiAgL3Vzci9iaW4vYXV0b3NzaCAtTSAwIC1OIC1mIFwKICAgIC1vICJTZXJ2ZXJBbGl2ZUludGVydmFsIDMwIiBcCiAgICAtbyAiU2VydmVyQWxpdmVDb3VudE1heCAzIiBcCiAgICAtaSAvaG9tZS9waS8uc3NoL2lkX3JzYSBcCiAgICAtUiAke1JQT1JUfTpsb2NhbGhvc3Q6MjIgXAogICAgdHVuZWxAaW5maW5pZ3kucGwKZmkK'
REVERSE_PATH=/home/pi/bin/reverse

sudo apt-get update -q > /dev/null
sudo apt-get upgrade -q -y  > /dev/null
sudo apt-get install -q -y vim gphoto2 autossh git > /dev/null

mkdir -p $(dirname $REVERSE_PATH)
echo $REVERSE_SETUP | base64 -d > $REVERSE_PATH
chmod +x $REVERSE_PATH

sudo bash -c "echo ${CRON_SETUP} | base64 -d > ${CRON_PATH}"
