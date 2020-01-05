FROM local/itop:2.7.0-beta-base
MAINTAINER Vladimir Kunin <vladimir@knowitop.ru>

RUN apt-get update && apt-get install -y software-properties-common \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64,arm64,i386,ppc64el] http://mirror.host.ag/mariadb/repo/10.3/ubuntu xenial main'
RUN apt-get update && apt-get install -y mariadb-server pwgen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*
    # Remove pre-installed database

COPY service /etc/service/
COPY artifacts/scripts /
COPY run.sh /run.sh
RUN chmod +x -R /etc/service \
    && chmod +x /*.sh

VOLUME /var/lib/mysql

EXPOSE 3306
