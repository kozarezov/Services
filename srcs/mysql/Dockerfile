FROM alpine:latest

# Install Mariadb
RUN apk update \
&& apk add mariadb mariadb-client openrc

ADD /srcs/setup.sh 			/srcs/setup.sh
ADD /srcs/wordpress.sql		/srcs/wordpress.sql

EXPOSE 3306

CMD ["sh", "/srcs/setup.sh"]