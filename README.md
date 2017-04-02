# nikon-rpi
First of all, the project name has nothing to do with the **Nikon** itself ;) It was choosen only because I was working only with **Nikon** cameras when developing this silly project.

Long story short:
- raspberry pi was used to capture a photo on camera using `gphoto2`
- camera was taken outside, placed in a glass box and ment to capture new photo every 10 minutes (yeah, time lapse)
- raspberry was connected to the Internet via LTE mobile modem
- I needed to have minimal monitoring-like tool to check, if camera captured it's pictures

## Requirements
The only and one requirement (at the moment at least) is the `flask` Python module.

## Setup
The `nikon-rpi-monitor.sh` needs to be executed periodically on raspberry pi connected to the camera. It simply reads the output of `gphoto2` which is streamed from cron to `/tmp/aparat.log` file.

To launch server you just simply executed
```sh
python nikon-rpi-server.py
```

# Docker
I just couldn't resist and did it for fun - **nikon-rpi** is now dockerized! You can just
```
docker pull s4ros/nikon-rpi
```
and enjoy my funny work :D

## Requirements

You need to pass some extra arguments to docker to run this containter properly :)

Example
```
docker run -d --rm --name nikon-rpi \
  -v /your/persistent/path:/rpi \
  -v /etc/localtime:/etc/localtime \
  -p 56789:56789 \
  s4ros/nikon-rpi
```
I know, that's a long one, but trust me, you want to do all of this :)

That said, we can do the first launch :)

# First Usage
When you'll run the container you need to request `http://<yourdockerhost>:56789/dbinit` to initialize the sql3 database. After initializing database you can just use `http://<yourdockerhost>:56789`
