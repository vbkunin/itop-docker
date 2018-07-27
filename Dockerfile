FROM phusion/baseimage
MAINTAINER Vladimir Kunin <vladimir@knowitop.ru>

ARG DEBIAN_FRONTEND=noninteractive

# Copy configs and scripts
COPY etc /etc/
COPY opt /opt/

RUN apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:ondrej/php \
 && apt-get update \
 && apt-get install -y \
      apache2 \
      git \
      graphviz \
      mariadb-server \
      php7.1 \
      php7.1-gd \
      php7.1-json \
      php7.1-ldap \
      php7.1-mbstring \
      php7.1-mcrypt \
      php7.1-mysql \
      php7.1-soap \
      php7.1-xml \
      php7.1-zip \
      unzip \
      wget \
      pwgen \
 && a2enmod rewrite \
  # Remove pre-installed database and apache demo data
 && rm -rf \
      /etc/apache2/sites-available/000-default.conf \
      /etc/apache2/sites-enabled/000-default.conf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/lib/mysql/* \
      /var/tmp/* \
      /var/www/html/* \
 && /opt/itop/bin/setup

VOLUME /root
VOLUME /var/backups
VOLUME /var/cache
VOLUME /var/lib/mysql
VOLUME /var/log

EXPOSE 80

ENTRYPOINT ["/opt/itop/bin/run"]
