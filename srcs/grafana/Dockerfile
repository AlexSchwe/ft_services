FROM telegraf
MAINTAINER aschwere

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN sed -i -e "s/TMPDB/grafana/g" /etc/telegraf/telegraf.conf

RUN apk update && apk add grafana@testing

COPY srcs/datasource.yaml usr/share/grafana/conf/provisioning/datasources/
COPY srcs/dashboards/* usr/share/grafana/conf/provisioning/dashboards/
CMD screen -dmS telegraf telegraf && screen -dmS grafana grafana-server --homepath "/usr/share/grafana/" && tail -F /dev/null
