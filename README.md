# gphoto2-rpi
~~First of all, the project name has nothing to do with the **Nikon** itself ;) It was choosen only because I was working only with **Nikon** cameras when developing this silly project.~~

Please, check the [Docker](#docker) part. Maybe you don't want to struggle with all of the manual installation :)

Long story short:
- raspberry pi was used to capture a photo on camera using `gphoto2`
- camera was taken outside, placed in a glass box and ment to capture new photo every 10 minutes (yeah, time lapse)
- raspberry was connected to the Internet via LTE mobile modem
- I needed to have minimal monitoring-like tool to check, if camera captured it's pictures

## Requirements
The only and one requirement (at the moment at least) is the `flask` Python module.

## Setup
The `gphoto2-rpi-monitor.sh` needs to be executed periodically on raspberry pi connected to the camera. It simply reads the output of `gphoto2` which is streamed from cron to `/tmp/aparat.log` file.

To launch server you just simply executed
```sh
python gphoto2-rpi-server.py
```

# Docker
I just couldn't resist and did it for fun - **gphoto2-rpi** is now dockerized! You can just
```
docker pull s4ros/gphoto2-rpi
```
and enjoy my funny work :D

## Requirements

You need to pass some extra arguments to docker to run this containter properly :)

Example
```
docker run -d --rm --name gphoto2-rpi \
  -v /your/persistent/path:/rpi \
  -v /etc/localtime:/etc/localtime:ro \
  --net=host \
  s4ros/gphoto2-rpi
```
I know, that's a long one, but trust me, you want to do all of this :)

That said, we can do the first launch :)

# First Usage
When you'll run the container you need to request `http://<yourdockerhost>:56789/dbinit` to initialize the sql3 database. After initializing database you can just use `http://<yourdockerhost>:56789`, though reverse proxy is the preffered way to go.
