FROM telegraf

MAINTAINER aschwere
ENV USER=www
ENV DB_NAME=wordpress 
ENV DB_USER=mysql 
ENV DB_PASS=pass
ENV DB_HOST=mysql

RUN sed -i -e "s/TMPDB/phpmyadmin/g" /etc/telegraf/telegraf.conf

RUN apk update
RUN apk add nginx

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY srcs/nginx.conf /etc/nginx/
RUN mkdir -p /run/nginx
RUN adduser -D -g ${USER} ${USER}
RUN chmod -R 777 /var/lib/nginx/
RUN chown -R ${USER}:${USER} /var/lib/nginx

RUN	apk add mysql mysql-client
RUN apk add gettext


RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session php7-zip
COPY srcs/config.inc.php .
RUN mkdir ${USER}


EXPOSE 5000
COPY srcs/start.sh /tmp/start.sh
CMD screen -dmS telegraf telegraf && /bin/sh /tmp/start.sh
