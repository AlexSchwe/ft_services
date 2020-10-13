FROM telegraf
MAINTAINER aschwere

ENV CERTIF=/etc/ssl/private/cert.pem
ENV CERTIF_KEY=/etc/ssl/private/key.pem


RUN sed -i -e "s/TMPDB/ftps/g" /etc/telegraf/telegraf.conf

RUN apk add vsftpd openssl gettext
RUN adduser -D ftpuser
RUN echo "ftpuser:pass" | chpasswd

#Create & make accessible the home path
RUN mkdir -p /home/ftpuser/ftp /etc/ssl/private /var/run/vsftpd/empty
RUN chown nobody:nogroup /home/ftpuser/ftp && chmod a-w /home/ftpuser/ftp
RUN echo "ftpuser" | tee -a /etc/vsftpd/vsftpd.userlist

#Creating test file
RUN echo "Hello world" > /home/ftpuser/ftp/hello.txt

COPY srcs/vsftpd.conf /tmp/vsftpd/vsftpd.conf
RUN openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -addext "subjectAltName=DNS:mydomain.com" -keyout ${CERTIF_KEY} -out ${CERTIF}
COPY srcs/start.sh /tmp/start.sh
RUN chmod 777 /tmp/start.sh

CMD /bin/sh /tmp/start.sh && tail -f /dev/null
EXPOSE 20 21 30000
