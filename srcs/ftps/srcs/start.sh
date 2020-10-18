envsubst '${MINIKUBE_IP}' < /tmp/vsftpd/vsftpd.conf > /etc/vsftpd/vsftpd.conf
screen -dmS telegraf telegraf
screen -dms ftps vsftpd /etc/vsftpd/vsftpd.conf
