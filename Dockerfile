FROM local/itop:2.6.0-beta-base
MAINTAINER Vladimir Kunin <vladimir@knowitop.ru>

RUN apt-get update && apt-get install -y mariadb-server pwgen
# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

COPY artifacts/create-mysql-admin-user.sh /create-mysql-admin-user.sh
COPY run.sh /run.sh
RUN chmod +x /*.sh

COPY service /etc/service/
RUN chmod +x -R /etc/service

VOLUME /var/lib/mysql

EXPOSE 3306
