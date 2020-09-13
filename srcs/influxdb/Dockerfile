FROM alpine:latest

RUN apk add influxdb ; \
	apk add openrc ; \
 	apk add ca-certificates

COPY script.sh /tmp

RUN chmod +x /tmp/script.sh

EXPOSE	8086


CMD /bin/sh /tmp/script.sh
