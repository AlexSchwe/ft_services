FROM telegraf

MAINTAINER aschwere
RUN apk update && apk add influxdb

#Set the proper database
RUN sed -i -e "s/TMPDB/influxdb/g" /etc/telegraf/telegraf.conf

#Telegraf should output to localhost, not to influxdb service
RUN sed -i -e "s/http:\/\/influxdb:/http:\/\/127.0.0.1:/g" /etc/telegraf/telegraf.conf

CMD screen -dmS telegraf telegraf && screen -dmS influxdb influxd && tail -F /dev/null

EXPOSE 8086
