FROM telegraf
MAINTAINER aschwere

#Set the proper database for influxdb
RUN sed -i -e "s/TMPDB/grafana/g" /etc/telegraf/telegraf.conf

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add grafana@testing


#Copy the datasources (one database for each container) and the dashboards, previously downloaded from the site
COPY srcs/datasource.yaml usr/share/grafana/conf/provisioning/datasources/
COPY srcs/dashboards/* usr/share/grafana/conf/provisioning/dashboards/

#Launches telegraf and grafana server
CMD screen -dmS telegraf telegraf && screen -dmS grafana grafana-server --homepath "/usr/share/grafana/" && tail -F /dev/null
