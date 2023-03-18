# syntax=docker/dockerfile:1

FROM ubuntu AS code
ARG DEBIAN_FRONTEND=noninteractive
ARG ITOP_DOWNLOAD_URL

RUN apt-get update && apt-get install -y curl unzip

# Get iTop and fix rights
RUN mkdir -p /tmp/itop \
    && curl -SL -o /tmp/itop/itop.zip ${ITOP_DOWNLOAD_URL:?} \
    && unzip /tmp/itop/itop.zip -d /tmp/itop/ \
    && find /tmp/itop/web/ -type d -exec chmod 555 {} \; \
    && find /tmp/itop/web/ -type f -exec chmod 444 {} \; \
    && chmod u+w /tmp/itop/web /tmp/itop/web/log /tmp/itop/web/data /tmp/itop/web/conf


FROM phusion/baseimage:jammy-1.0.1 AS base
LABEL title="Docker image with Combodo iTop"
LABEL version="1.0.0"
LABEL url="https://github.com/vbkunin/itop-docker"

ARG DEBIAN_FRONTEND=noninteractive

# Install and configure Apache Httpd and PHP
RUN apt-get update && apt-get install -y software-properties-common ca-certificates \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
        apache2 \
        php8.0 php8.0-xml php8.0-mysql php8.0-mbstring php8.0-ldap php8.0-soap php8.0-zip php8.0-gd php8.0-curl php8.0-apcu \
        graphviz \
        curl \
        unzip\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --set php /usr/bin/php8.0

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
COPY --link --from=code --chown=www-data:www-data /tmp/itop/web /var/www/html

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
