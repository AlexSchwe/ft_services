sed -i -e 's@$(MINIKUBE_IP)@'$MINIKUBE_IP'@' /etc/nginx/nginx.conf
screen -dmS telegraf telegraf
/usr/sbin/sshd
nginx -g "daemon on;"
