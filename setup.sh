ADDONS=("metrics-server" "dashboard" "metallb" "default-storageclass" "storage-provisioner")
#UNITS=("nginx" "ftps" "mysql" "wordpress" "phpmyadmin" "influxdb" "grafana")
UNITS=("nginx" "ftps" "mysql" "wordpress" "phpmyadmin" "influxdb" "grafana")

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
	minikube start --vm-driver=$VMDRIVER --cpus=$VMCORE  --memory=$MEMORY
#	minikube start --vm-driver=docker

	for ADDON in ${ADDONS[@]}; do
		minikube addons enable "${ADDON}"
		done

	#Installing metallb
	kubectl apply -f metallb.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

	export MINIKUBE_IP=$(minikube ip)
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
		sed 's@$(MINIKUBE_IP)@'$MINIKUBE_IP'@g' srcs/${UNIT}/${UNIT}.yaml > srcs/${UNIT}/${UNIT}_service.yaml
		kubectl apply -f srcs/${UNIT}/${UNIT}_service.yaml
		#destroy the yaml file with Minikube_ip
		rm srcs/${UNIT}/${UNIT}_service.yaml
		done
}

launch_minikube
build_services
screen -dmS "minikube dashboard"
