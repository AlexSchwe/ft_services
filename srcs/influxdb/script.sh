#Starts server in the background
influxd run -config /etc/influxdb.conf > influx.log 2>&1 &
#Create database
influx -execute "CREATE DATABASE $DB"

#Create user
influx -execute "CREATE USER $DB_USER WITH PASSWORD $DB_PASS WITH ALL PRIVILEGES"
tail -f /dev/null
