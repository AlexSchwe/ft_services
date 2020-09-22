#Starts server in the background
influxd run -config /etc/influxdb.conf > influx.log 2>&1 &
tail -f /dev/null
