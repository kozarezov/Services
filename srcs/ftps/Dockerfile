FROM alpine:latest

# Install FTPS and dependencis
RUN apk update \
&& apk add vsftpd && apk add openssl curl

ADD /srcs/vsftpd.conf			/etc/vsftpd/vsftpd.conf
ADD /srcs/setup.sh				/srcs/setup.sh
ADD /srcs/livenessprobe.sh		/srcs/livenessprobe.sh

# CONFIG OPENSSL
RUN openssl req -x509 -nodes -subj '/C=RU/ST=Krasnodarski/L=Krasnodar/O=School21/OU=School/CN=ceccentr' \
		-days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key \
		-out /etc/ssl/certs/vsftpd.crt

EXPOSE 20 21 21000-21010

CMD ["sh", "/srcs/setup.sh"]