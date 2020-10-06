echo "Waiting for Address before launch ftps"
while true
do
	#Put the right address into vsftpd.conf
	if [ `kubectl exec deploy/ftps -- grep -H "REPLACEME" /etc/vsftpd/vsftpd.conf` ]
	then
		IPFTPS=`kubectl get services/ftps -o=custom-columns='ADDRESS:status.loadBalancer.ingress[0].ip'|tail -n1`
		while [ $IPFTPS = '<none>' ]
		do
			sleep 1
			IPFTPS=`kubectl get services/ftps -o=custom-columns='ADDRESS:status.loadBalancer.ingress[0].ip'|tail -n1`
		done

		kubectl exec deploy/ftps -- pkill vsftpd
		kubectl exec deploy/ftps -- sed -ie "s/REPLACEME/$IPFTPS/g" /etc/vsftpd/vsftpd.conf
		kubectl exec deploy/ftps -- screen -dmS ftps vsftpd /etc/vsftpd/vsftpd.conf
	fi
	sleep 10
done
