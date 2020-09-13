
function set_goinfre()
{
	if [ -d "/goinfre" ]; then
		# Ensure USER variabe is set
		[ -z "${USER}" ] && export USER=`whoami`

		mkdir -p /goinfre/$USER

		# Set the minikube directory in /goinfre
		export MINIKUBE_HOME="/goinfre/$USER"
	fi
}
function set_minikube()
{
	if minikube &> /dev/null
	then
		echo -ne "\033[1;33m+>\033[0;33m Minikube check for upgrade ... \n"
		if brew upgrade minikube &> /dev/null
		then
			echo -ne "\033[1;32m+>\033[0;33m Minikube updated ! \n"
		else
			echo -ne "\033[1;31m+>\033[0;33m Error... During minikube update. \n"
			exit 1
		fi
	else
		echo -ne "\033[1;31m+>\033[0;33m Minikube installation ...\n"
		if brew install minikube &> /dev/null
		then
			echo -ne "\033[1;32m+>\033[0;33m Minikube installed ! \n"
		else
			echo -ne "\033[1;31m+>\033[0;33m Error... During minikube installation. \n"
		fi
	fi
}

#set_goinfre
##set_minikube

ADDONS=("metrics-server" "dashboard" "metallb" "default-storageclass" "storage-provisioner")
#UNITS=("influxdb" "telegraf" "grafana" "nginx" "mysql" "wordpress" "phpmyadmin")
UNITS=("nginxtest")
function launch_minikube()
{
	minikube delete
	minikube start --vm-driver=virtualbox --memory 2000

	for ADDON in ${ADDONS[@]}; do
		minikube addons enable "${ADDON}"
		done

	kubectl apply -f metallb.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	export MINIKUBE_IP=$(minikube ip)
}

function build_services()
{
	eval $(minikube docker-env)
	for UNIT in ${UNITS[@]}; do
		docker build -t "${UNIT}" srcs/${UNIT}
		echo "docker build -t "${UNIT}" srcs/${UNIT}"
		sed 's@$(MINIKUBE_IP)@'$MINIKUBE_IP'@g' srcs/${UNIT}/${UNIT}.yaml > srcs/${UNIT}/${UNIT}_service.yaml
		kubectl apply -f srcs/${UNIT}/${UNIT}_service.yaml
		rm srcs/${UNIT}/${UNIT}_service.yaml
		echo "kubectl apply -f srcs/${UNIT}/${UNIT}.yaml"
		done
}

function print_dashboard()
{
	echo "minikube dashboard" > /tmp/dashboard.command
	chmod +x /tmp/dashboard.command
	open /tmp/dashboard.command
}

launch_minikube
build_services
#print_dashboard
