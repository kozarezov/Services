#!/bin/bash

# Color Text
################################################################################

# Red="\e[31m"			#--------- Red color
Light_red="\e[91m"		#--------- Light red color
Green="\e[32m"			#--------- Green color
Yellow="\e[33m"			#--------- Yellow color
Blue="\e[34m"			#--------- Blue color
Default_color="\e[39m"	#--------- Default color

################################################################################

start_minikube()
{
	minikube delete
	minikube start --vm-driver=virtualbox --disk-size=5000MB
	eval $(minikube docker-env)
}

install_addons_minikube()
{
	sleep 3
	minikube addons enable metrics-server
	minikube addons enable logviewer
	minikube addons enable metrics-server
}

install_build_metallb_secret()
{
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml > /dev/null
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml > /dev/null
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" > /dev/null
	printf "\n✅ : Install [${Yellow}Metallb${Default_color}]\n"
	kubectl apply -f srcs/config/metallb.yaml > /dev/null
	printf "🔒 : Install [${Yellow}Secrets${Default_color}]\n"
	kubectl apply -f srcs/config/secret.yaml > /dev/null
}

docker_build()
{
	services="ftps grafana nginx mysql wordpress phpmyadmin influxdb telegraf"
	for service in $services
	do
		printf "✅ : docker build images   [${Green}$service${Default_color}]\n"
		docker build -t alpine_$service srcs/$service > /dev/null
	done
}

kubernetes_build()
{
	services="ftps grafana nginx mysql wordpress phpmyadmin influxdb telegraf"
	for service in $services
	do
		printf "✅ : kubernetes deployment [${Blue}$service${Default_color}]\n"
		kubectl apply -f srcs/$service/"$service"-deployment.yaml > /dev/null
	done
	printf "\n🎉 : ${Green}Images docker and kubernetes build${Default_color} 🎉\n"
}

display_service()
{
	printf "\n : FT_SERVICES ${Green}READY${Default_color}\n"
	echo " ---------------------------------------------------------------------------------------"
	printf "| ${Blue}Wordpress${Default_color}	 | user: admin     | password: admin    | ip: http://"
	kubectl get svc | grep wordpress-service | cut -d " " -f 11,12,13 | tr -d "\n" | tr -d " "
	printf ":5050  |\n"
	echo " ---------------------------------------------------------------------------------------"
	printf "| ${Yellow}PhpMyAdmin${Default_color}     | user: wp_user   | password: password | ip: http://"
	kubectl get svc | grep phpmyadmin-service | cut -d " " -f 10,11,12 | tr -d "\n" | tr -d " "
	printf ":5000  |\n"
	echo " ---------------------------------------------------------------------------------------"
	printf "| ${Green}Ftps${Default_color}           | user: ftps_user | password: password | ip: "
	kubectl get svc | grep ftps-service | cut -d " " -f 15,16,17,18 | tr -d "\n" | tr -d " "
	printf ":21           |\n"
	echo " ---------------------------------------------------------------------------------------"
	printf "| ${Light_red}Grafana${Default_color}        | user: admin     | password: admin    | ip: http://"
	kubectl get svc | grep grafana-service | cut -d " " -f 13,14,15 | tr -d "\n" | tr -d " "
	printf ":3000  |\n"
	echo " ---------------------------------------------------------------------------------------"
	printf "| ${Orange}Nginx${Default_color}          | user: ssh_user  | password: password | ip: https://"
	kubectl get svc | grep nginx-service | cut -d " " -f 15,16,17 | tr -d "\n" | tr -d " "
	printf ":443  |\n"
	echo " ---------------------------------------------------------------------------------------"
}

run_minikube_dashboard()
{
	printf "\n : Minikube ${Light_red}Dashboard${Default_color}\n"
	minikube dashboard
	sleep 2
	minikube dashboard
}

main()
{
	bash srcs/config/install_program.sh
	printf "\n ${Yellow}----------------------------------"
	printf "\n ---------START BUILDING----------- \n\n"
	printf "${Default_color}"
	start_minikube
	install_addons_minikube
	install_build_metallb_secret
	docker_build
	kubernetes_build
	printf "${Default_color}"
	display_service
	run_minikube_dashboard
}

main