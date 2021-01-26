FROM alpine:latest

# Install Nginx and dependencies
RUN apk update && apk add openrc \
&& apk add nginx openssl openssh

ADD /srcs/nginx.conf		/etc/nginx/nginx.conf
ADD /srcs/setup.sh 			/srcs/setup.sh
RUN chmod +x 				/srcs/setup.sh
RUN mkdir www
ADD /srcs//livenessprobe.sh	/srcs/livenessprobe.sh

# CONFIG OPENSSL
RUN openssl req -x509 -nodes -subj '/C=RU/ST=Krasnodarski/L=Krasnodar/O=School21/OU=School/CN=ceccentr' \
		 -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-my.key \
		 -out /etc/ssl/certs/nginx-my.crt
# CONGIF SSH
ADD /srcs/sshd_config 		/etc/ssh/

EXPOSE 22 80 443

CMD ["sh", "/srcs/setup.sh"]