FROM alpine:latest

RUN	wget -P /tmp/  https://dl.grafana.com/oss/release/grafana-6.7.1.linux-amd64.tar.gz ; \
	tar -zxvf /tmp/grafana-6.7.1.linux-amd64.tar.gz 

RUN	set -ex ; \
	addgroup -S grafana ; \
	adduser -S -G grafana grafana ; \
	apk add --no-cache libc6-compat ca-certificates su-exec bash ; \
	apk add openrc

RUN mkdir /grafana-6.7.1/conf/provisioning/dashboards/mine

COPY srcs/datasource/datasource.yaml /tmp/datasource.yaml
COPY srcs/dashboards/sample.yaml /grafana-6.7.1/conf/provisioning/dashboards/
COPY srcs/dashboards/*.json /grafana-6.7.1/conf/provisioning/dashboards/mine/

EXPOSE	3000
COPY setup.sh /tmp/setup.sh
RUN apk add gettext


RUN	chmod 775 /tmp/setup.sh

CMD	/bin/sh /tmp/setup.sh
