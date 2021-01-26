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

load_animation()
{
	sleep 3
	spin='-\|/'
	while kill -0 $1 2>/dev/null
	do
		printf "\r🤖 : Install in progress "
	  	printf "${spin:i++%${#spin}:1}"
	  	sleep .1
	done
}

install_virtualbox()
{
	if [ "$(VboxManage > /dev/null && echo $?)" == "0" ]; then
			printf "✅ : VirtualBox installed\n"
	else
		printf "❗ : Please install ${Light_red}VirtualBox"
		exit
	fi
}

install_docker()
{
	if [ "$(ls /Applications | grep Docker.app)" == "Docker.app" ]; then
			printf "✅ : Docker installed\n"
	else
		printf "❗ : Please install ${Light_red}Docker"
		exit
	fi
}

install_brew()
{
	if [ "$(brew list > /dev/null 2>&1 && echo $?)" != "0" ]; then
		rm -rf $HOME/.brew &
		git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew &
		echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc &
		source $HOME/.zshrc &
		brew update
	fi
	printf "✅ : Brew installed\n"
}

install_minikube()
{
	if [ "$(brew list | grep minikube)" != "minikube" ]; then
		printf "🤖 : Install Minikube\n"
		brew install minikube &> /dev/null & 
		load_animation $!
		printf "\b \n"
	fi
	printf "✅ : Minikube installed\n"
}

main()
{
	printf "\n ${Yellow}----------------------------------"
	printf "\n --------CHECK INSTALLING---------- \n\n"
	printf "${Default_color}"
	install_virtualbox
	install_docker
	install_brew
	install_minikube
}

main