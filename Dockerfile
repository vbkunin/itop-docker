FROM phusion/baseimage
MAINTAINER Vladimir Kunin <vladimir@knowitop.ru>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:ondrej/php \
 && apt-get update \
 && apt-get install -y \
    apache2 \
    php7.1 php7.1-xml php7.1-mysql php7.1-json php7.1-mcrypt \
    php7.1-mbstring php7.1-ldap php7.1-soap php7.1-zip \
    php7.1-gd \
    graphviz \
    git wget unzip \
    mariadb-server pwgen \
    # Remove pre-installed database and apache demo data
 && rm -rf /var/lib/mysql/* /var/www/html/*
 && mkdir /opt/itop

# Copy configs and scripts
COPY artifacts/itop-setip.sh /opt/itop/setup
COPY artifacts/setup-itop-cron.sh /setup-itop-cron.sh
COPY artifacts/itop-cron.logrotate /etc/logrotate.d/itop-cron
# Copy update Russian translations script
COPY artifacts/update-russian-translations.sh /update-russian-translations.sh
# Copy iTop config-file rights management scripts
COPY artifacts/make-itop-config-writable.sh /make-itop-config-writable.sh
COPY artifacts/make-itop-config-read-only.sh /make-itop-config-read-only.sh
# Copy Tookit installation script
COPY artifacts/install-toolkit.sh /install-toolkit.sh
COPY artifacts/create-mysql-admin-user.sh /create-mysql-admin-user.sh
COPY run.sh /run.sh
COPY service /etc/service/

RUN chmod +x /*.sh \
    # Create shortcuts for the right management scripts
 && ln -s /opt/itop/setup /usr/local/bin/itop-setup \
 && ln -s /make-itop-config-writable.sh /usr/local/bin/conf-w \
 && ln -s /make-itop-config-read-only.sh /usr/local/bin/conf-ro \
    # Get iTop
 && mkdir -p /tmp/itop \
 && wget --no-check-certificate -O /tmp/itop/itop.zip \
    https://sourceforge.net/projects/itop/files/itop/2.5.0/iTop-2.5.0-3935.zip \
 && unzip /tmp/itop/itop.zip -d /tmp/itop/ \
 && mv /tmp/itop/web/* /var/www/html \
    # Get latest Russian translations
 && /update-russian-translations.sh \
 && chown -R www-data:www-data /var/www/html \
 && chmod +x -R /etc/service \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /root
VOLUME /var/backups
VOLUME /var/cache
VOLUME /var/lib/mysql
VOLUME /var/log
VOLUME /var/www/html

EXPOSE 80

CMD ["/run.sh"]
