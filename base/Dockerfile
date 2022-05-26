FROM phusion/baseimage:focal-1.1.0
MAINTAINER Vladimir Kunin <we@knowitop.ru>

ARG DEBIAN_FRONTEND=noninteractive
ARG ITOP_VERSION=3.0.1
ARG ITOP_FILENAME=iTop-3.0.1-9191.zip

RUN apt-get install -y software-properties-common ca-certificates \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
        apache2 \
        php7.4 php7.4-xml php7.4-mysql php7.4-json php7.4-mbstring php7.4-ldap php7.4-soap php7.4-zip php7.4-gd php7.4-curl php7.4-apcu \
        graphviz \
        curl \
        unzip\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --set php /usr/bin/php7.4

# Get iTop
RUN rm -rf /var/www/html/* \
    && mkdir -p /tmp/itop \
    && curl -SL -o /tmp/itop/itop.zip https://sourceforge.net/projects/itop/files/itop/$ITOP_VERSION/$ITOP_FILENAME/download \
    && unzip /tmp/itop/itop.zip -d /tmp/itop/ \
    && mv /tmp/itop/web/* /var/www/html \
    && rm -rf /tmp/itop

# Copy services, configs and scripts
COPY service /etc/service/
COPY artifacts/scripts /
COPY artifacts/itop-cron.logrotate /etc/logrotate.d/itop-cron
COPY artifacts/apache2.fqdn.conf /etc/apache2/conf-available/fqdn.conf
COPY artifacts/apache2.security.conf /etc/apache2/conf-available/security.conf

COPY run.sh /run.sh
RUN chmod +x -R /etc/service \
    && chmod +x /*.sh \
    && a2enconf fqdn \
    && a2enconf security \
    && a2enmod headers

# Create shortcuts for the right management scripts and fix rights
RUN ln -s /make-itop-config-writable.sh /usr/local/bin/conf-w \
    && ln -s /make-itop-config-read-only.sh /usr/local/bin/conf-ro \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html/ -type d -exec chmod 555 {} \; \
    && find /var/www/html/ -type f -exec chmod 444 {} \; \
    && chmod u+w /var/www/html /var/www/html/log /var/www/html/data

WORKDIR /var/www/html

EXPOSE 80

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/run.sh"]