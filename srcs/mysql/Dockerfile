FROM telegraf

MAINTAINER aschwere
ENV DB_NAME=wordpress 
ENV DB_USER=mysql 
ENV DB_PASS=pass
RUN	apk add mysql mysql-client
RUN apk add gettext


RUN sed -i -e "s/TMPDB/mysql/g" /etc/telegraf/telegraf.conf
COPY my.cnf /tmp/my.cnf
RUN envsubst '${DB_USER} ${DB_PASS}' < /tmp/my.cnf > /etc/my.cnf
VOLUME /var/lib/mysql

RUN :> /tmp/sql
RUN echo "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;" >> /tmp/sql
RUN echo "SET PASSWORD FOR '$DB_USER'@'localhost'=PASSWORD('${DB_PASS}') ;" >> /tmp/sql
RUN echo "GRANT ALL ON *.* TO '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;" >> /tmp/sql
RUN echo "GRANT ALL ON *.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;" >> /tmp/sql
RUN echo "GRANT ALL ON *.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;" >> /tmp/sql
RUN echo "FLUSH PRIVILEGES;" >> /tmp/sql
RUN cat /tmp/sql

RUN :> /tmp/start.sh
RUN echo "mysql_install_db --user=mysql --ldata=/var/lib/mysql" >> /tmp/start.sh
RUN echo "/usr/bin/mysqld --console --init_file=/tmp/sql" >> /tmp/start.sh
EXPOSE 3306
CMD screen -dmS telegraf telegraf && /bin/sh /tmp/start.sh
