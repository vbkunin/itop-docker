FROM phusion/baseimage
MAINTAINER Vladimir Kunin <vladimir@knowitop.ru>

ARG DEBIAN_FRONTEND=noninteractive
ARG ITOP_VERSION=2.6.0
ARG ITOP_FILENAME=iTop-2.6.0-4294.zip

RUN apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:ondrej/php \
 && apt-get update

RUN apt-get install -y \
    apache2 \
    php7.1 php7.1-xml php7.1-mysql php7.1-json php7.1-mcrypt php7.1-mbstring php7.1-ldap php7.1-soap php7.1-zip php7.1-gd \
    graphviz curl \
    git wget unzip

# Get iTop
RUN mkdir -p /tmp/itop
RUN wget --no-check-certificate -O /tmp/itop/itop.zip https://sourceforge.net/projects/itop/files/itop/$ITOP_VERSION/$ITOP_FILENAME/download
RUN unzip /tmp/itop/itop.zip -d /tmp/itop/
RUN rm -rf /var/www/html/* && mv /tmp/itop/web/* /var/www/html

# Copy services, configs and scripts
COPY service /etc/service/
COPY artifacts/itop-cron.logrotate /etc/logrotate.d/itop-cron
COPY artifacts/apache2.fqdn.conf /etc/apache2/conf-available/fqdn.conf
COPY artifacts/scripts /
COPY run.sh /run.sh
RUN chmod +x -R /etc/service
RUN chmod +x /*.sh
RUN a2enconf fqdn

# Create shortcuts for the right management scripts
RUN ln -s /make-itop-config-writable.sh /usr/local/bin/conf-w
RUN ln -s /make-itop-config-read-only.sh /usr/local/bin/conf-ro

# Get latest Russian translations
RUN /update-russian-translations.sh

RUN chown -R www-data:www-data /var/www/html

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/run.sh"]
