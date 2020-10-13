FROM alpine:latest
MAINTAINER aschwere

RUN	mkdir -p /etc/telegraf 

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add screen telegraf@testing
#RUN mkdir -p /etc/telegraf  
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf

#Used only as image, hence no command nor entrypoint
