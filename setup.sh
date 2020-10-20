#!/bin/bash

ADDONS=("metrics-server" "dashboard" "default-storageclass" "storage-provisioner")
UNITS=("nginx" "ftps" "influxdb" "mysql" "wordpress" "phpmyadmin" "grafana")

function launch_minikube()
{
	minikube delete

	if [ `uname -s` = 'Linux' ]
	then
		#VM settingd
		VMDRIVER="docker"
		VMCORE=2
		MEMORY=5000
	else
		#Personnal settings: feel free to change
		VMDRIVER="virtualbox"
		VMCORE=2
		MEMORY=2000
	fi

	#params are to be set according to your hardware
	minikube start --extra-config=apiserver.service-node-port-range=1-65535 --vm-driver=$VMDRIVER --cpus=$VMCORE  --memory=$MEMORY


	for ADDON in ${ADDONS[@]}; do
		minikube addons enable "${ADDON}"
		done

	#Installing metallb
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

	if [ $VMDRIVER = 'docker' ]
	then
		MINIKUBE_IP=`docker inspect minikube --format="{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}"`
	else
		MINIKUBE_IP=`minikube ip`
	fi

	IP=`echo $MINIKUBE_IP|awk -F '.' '{print $1"."$2"."$3"."128}'`
	cp srcs/metallb.yaml srcs/metallb_tmp.yaml
	sed -ie "s/TMPIP/$IP/g" srcs/metallb_tmp.yaml
	kubectl apply -f srcs/metallb_tmp.yaml
	rm srcs/metallb_tmp.yaml

	export IP
}

function build_services()
{
	eval $(minikube docker-env)

	#Build the telegraf image inside each every container will be ran
	docker build -t telegraf srcs/telegraf/

	#Build every unit
	for UNIT in ${UNITS[@]}; do
		docker build -t "${UNIT}" srcs/${UNIT}
		#pass minikube ip when needed as ENV variable
		sed 's@$(MINIKUBE_IP)@'$IP'@g' srcs/${UNIT}/${UNIT}.yaml > srcs/${UNIT}/${UNIT}_service.yaml
		kubectl apply -f srcs/${UNIT}/${UNIT}_service.yaml
		#destroy the yaml file with Minikube_ip
		rm srcs/${UNIT}/${UNIT}_service.yaml
		done
}

launch_minikube
build_services

echo "ssh www@$IP password:www"
echo "phpmyadmin mysql:pass"
echo "grafana admin:admin"
echo "ftps ftpuser:pass"
echo "curl -k --head https://$IP/wordpress"
echo "sudo apt-get install filezilla"

