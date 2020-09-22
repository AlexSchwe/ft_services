FROM telegraf

MAINTAINER aschwere
ENV DB_NAME=wordpress 
ENV DB_USER=mysql 
ENV DB_PASS=pass
ENV PORT=5000
ENV AUTHOR=aschwere

RUN apk update
RUN apk add nginx

RUN sed -i -e "s/TMPDB/wordpress/g" /etc/telegraf/telegraf.conf

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY srcs/nginx.conf /etc/nginx/
RUN mkdir -p /run/nginx
RUN adduser -D -g www www
RUN chmod -R 777 /var/lib/nginx/
RUN chown -R www:www /var/lib/nginx

RUN apk add gettext mysql-client curl php7-common php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session php7-phar php7-cli php7-zip php7-iconv php7-xml php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom

COPY srcs/wp-config.php /tmp/wp-config.php
RUN mkdir /www
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN mv wp-cli.phar /usr/bin/wp-cli

RUN chmod 777 /usr/bin/wp-cli
COPY srcs/start.sh /tmp/start.sh

EXPOSE 5050
RUN chmod 777 /tmp/start.sh
CMD screen -dmS telegraf telegraf && /bin/sh /tmp/start.sh
