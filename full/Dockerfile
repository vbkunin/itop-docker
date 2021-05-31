FROM vbkunin/itop:3.0.0-beta-base
MAINTAINER Vladimir Kunin <vladimir@knowitop.ru>

RUN apt-get update && apt-get install -y software-properties-common \
    && apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
    && add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.klaus-uwe.me/mariadb/repo/10.3/ubuntu bionic main'
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
