FROM telegraf

MAINTAINER aschwere

ENV CERTIF=/etc/ssl/certs/nginx-selfsigned.crt
ENV CERTIF_KEY=/etc/ssl/private/nginx-selfsigned.key
ENV USER=www

#Set the proper database for influx
RUN sed -i -e "s/TMPDB/nginx/g" /etc/telegraf/telegraf.conf

RUN apk update
RUN apk add nginx
RUN apk add openssl

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY srcs/nginx.conf /etc/nginx/
COPY srcs/proxy_params /etc/nginx/

#Create certifs
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -addext "subjectAltName=DNS:mydomain.com" -newkey rsa:2048 -keyout ${CERTIF_KEY} -out ${CERTIF}
RUN sed -i -e 's@CERTIF_KEY@'$CERTIF_KEY'@' /etc/nginx/nginx.conf
RUN sed -i -e 's@CERTIF@'$CERTIF'@' /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx
RUN adduser -D -g www www
RUN echo "www:www" | chpasswd


RUN mkdir /www
COPY srcs/index.html /www/
RUN chown -R www:www /www/
RUN chmod -R 755 /www/

#Setup ssh connection
RUN apk add openssh
COPY srcs/sshd_config /etc/ssh/
RUN /usr/bin/ssh-keygen -A

EXPOSE 80 443 22

COPY srcs/start.sh /tmp/
RUN chmod 777 /tmp/start.sh


CMD /bin/sh /tmp/start.sh && tail -f /dev/null
