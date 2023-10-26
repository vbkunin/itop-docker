# syntax=docker/dockerfile:1

ARG ITOP_TMP=/tmp/itop
ARG ITOP_TMP_WEB=${ITOP_TMP:?}/web

FROM ubuntu AS code

ARG DEBIAN_FRONTEND=noninteractive
ARG ITOP_DOWNLOAD_URL

ARG ITOP_TMP
ARG ITOP_TMP_WEB

RUN apt-get update && apt-get install -y curl unzip

# Get iTop and fix rights
RUN mkdir -p ${ITOP_TMP:?} \
    && curl -SL -o ${ITOP_TMP}/itop.zip ${ITOP_DOWNLOAD_URL:?} \
    && unzip ${ITOP_TMP}/itop.zip -d ${ITOP_TMP}/ \
    && chmod -R a=r ${ITOP_TMP_WEB} \
    && find ${ITOP_TMP_WEB} -type d -exec chmod a+x {} \; \
    && chmod u+w ${ITOP_TMP_WEB} ${ITOP_TMP_WEB}/log ${ITOP_TMP_WEB}/data ${ITOP_TMP_WEB}/conf


FROM phusion/baseimage:jammy-1.0.1 AS base

LABEL title="Docker image with Combodo iTop"
LABEL version="1.1.0"
LABEL url="https://github.com/vbkunin/itop-docker"

ARG DEBIAN_FRONTEND=noninteractive

ARG ITOP_TMP_WEB

# Install and configure Apache Httpd and PHP
RUN apt-get update && apt-get install -y software-properties-common ca-certificates \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
        apache2 \
        php8.1 php8.1-xml php8.1-mysql php8.1-mbstring php8.1-ldap php8.1-soap php8.1-zip php8.1-gd php8.1-curl php8.1-apcu php8.1-imap \
        graphviz \
        curl \
        unzip\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --set php /usr/bin/php8.1

# Copy services, configs and scripts
COPY base/service /etc/service/
COPY base/artifacts/scripts /
COPY base/artifacts/itop-cron.logrotate /etc/logrotate.d/itop-cron
COPY base/artifacts/apache2.fqdn.conf /etc/apache2/conf-available/fqdn.conf
COPY base/artifacts/apache2.security.conf /etc/apache2/conf-available/security.conf

RUN a2enconf fqdn \
    && a2enconf security \
    && a2enmod headers \
    && chmod +x -R /etc/service \
    && chmod +x /*.sh \
    && ln -s /make-itop-config-writable.sh /usr/local/bin/conf-w \
    && ln -s /make-itop-config-read-only.sh /usr/local/bin/conf-ro \
    && rm -rf /var/www/html

# Copy iTop code
COPY --from=code --chown=www-data:www-data ${ITOP_TMP_WEB:?} /var/www/html

WORKDIR /var/www/html

EXPOSE 80

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1


FROM base AS full

RUN apt-get update && apt-get install -y mariadb-server-10.6 pwgen ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*
    # Remove pre-installed database

COPY full/service /etc/service/
COPY full/my_init.d /etc/my_init.d/
COPY full/artifacts/scripts /
RUN chmod +x -R /etc/service \
    && chmod +x /etc/my_init.d/*.sh \
    && chmod +x /*.sh

VOLUME /var/lib/mysql

EXPOSE 3306
