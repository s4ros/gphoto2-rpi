FROM python:2.7-alpine

RUN apk add --update --no-cache\
    py-pip \
    build-base \
  && pip install flask

RUN mkdir /rpi
VOLUME /rpi

COPY static /static
COPY templates /templates
COPY gphoto2-rpi-server.py /gphoto2-rpi-server.py

EXPOSE 56789

CMD ["python","/gphoto2-rpi-server.py"]
