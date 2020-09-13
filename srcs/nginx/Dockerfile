FROM alpine:latest

ENV CERTIF=/etc/ssl/certs/nginx-selfsigned.crt
ENV CERTIF_KEY=/etc/ssl/private/nginx-selfsigned.key
ENV USER=www

RUN apk update
RUN apk add nginx
RUN apk add openssl

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY srcs/nginx.conf /etc/nginx/
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -addext "subjectAltName=DNS:mydomain.com" -newkey rsa:2048 -keyout ${CERTIF_KEY} -out ${CERTIF}
RUN sed -i -e 's@CERTIF_KEY@'$CERTIF_KEY'@' /etc/nginx/nginx.conf
RUN sed -i -e 's@CERTIF@'$CERTIF'@' /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx
RUN adduser -D -g www www

RUN mkdir /www
COPY srcs/index.html /www/
RUN chown -R www:www /www/
RUN chmod -R 755 /www/

RUN apk add openssh
COPY srcs/sshd_config /etc/ssh/
RUN ssh-keygen -A
EXPOSE 80 443 22
CMD tail -f /dev/null
#CMD /usr/sbin/sshd && nginx -g "daemon off;"
