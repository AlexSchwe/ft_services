export IP=`echo $MINIKUBE_IP|awk -F '.' '{print $1"."$2"."$3"."128}'`
envsubst '${IP}' < /tmp/vsftpd/vsftpd.conf > /etc/vsftpd/vsftpd.conf
screen -dmS telegraf telegraf
screen -dms ftps vsftpd /etc/vsftpd/vsftpd.conf
