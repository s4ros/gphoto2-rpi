FROM python:2.7-alpine

RUN apk add --update --no-cache\
    py-pip \
    build-base \
  && pip install flask

RUN mkdir /rpi
VOLUME /rpi

COPY static /static
COPY templates /templates
COPY nikon-rpi-server.py /nikon-rpi-server.py

EXPOSE 56789

CMD ["python","/nikon-rpi-server.py"]
