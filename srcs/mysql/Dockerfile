FROM telegraf

MAINTAINER aschwere
ENV DB_NAME=wordpress 
ENV DB_USER=mysql 
ENV DB_PASS=pass
RUN	apk add mysql mysql-client

#Needed for envsubst
RUN apk add gettext

#Set the right database for influxdb
RUN sed -i -e "s/TMPDB/mysql/g" /etc/telegraf/telegraf.conf
COPY srcs/my.cnf /tmp/my.cnf

#Pass the right env variable to my.cnf
VOLUME /var/lib/mysql

#Create the file that will be used for creating the database
RUN :> /tmp/sql
RUN echo "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;" >> /tmp/sql
RUN echo "SET PASSWORD FOR '$DB_USER'@'localhost'=PASSWORD('${DB_PASS}') ;" >> /tmp/sql
RUN echo "GRANT ALL ON *.* TO '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;" >> /tmp/sql
RUN echo "GRANT ALL ON *.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;" >> /tmp/sql
RUN echo "GRANT ALL ON *.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;" >> /tmp/sql
RUN echo "FLUSH PRIVILEGES;" >> /tmp/sql
RUN cat /tmp/sql

RUN mkdir /run/mysqld
RUN chmod 777 /run/mysqld

RUN envsubst '${DB_USER} ${DB_PASS}' < /tmp/my.cnf > /etc/my.cnf
#Will install my sql based on the file /tmp/mysql
COPY srcs/start.sh /tmp/
RUN chmod 777 /tmp/start.sh

EXPOSE 3306

CMD screen -dmS telegraf telegraf && /bin/sh /tmp/start.sh
