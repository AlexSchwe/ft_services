FROM telegraf

MAINTAINER aschwere

ENV USER=aschwere
RUN apk upgrade
RUN apk add openssl vsftpd
RUN apk add jq curl
ENV API_URL=https://kubernetes

RUN sed -i -e "s/TMPDB/ftps/g" /etc/telegraf/telegraf.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=Fr/ST=Bretagne/O=42/CN=Alexandre Schwerer' -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt
RUN mkdir -p /var/ftp

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN mkdir /$USER

RUN adduser -D -h /var/ftp $USER
RUN echo "$USER:pass" | chpasswd
EXPOSE 20 21 30000
CMD screen -dmS telegraf telegraf && vsftpd /etc/vsftpd/vsftpd.conf
