FROM phusion/baseimage
MAINTAINER Vladimir Kunin <vladimir@knowitop.ru>

ARG DEBIAN_FRONTEND=noninteractive
# Provide Build-Argument to skip MySQL installation
# Use with '--build-arg NO_DATABASE=true' during docker build
ARG NO_DATABASE=false
ENV no_database=$NO_DATABASE

RUN apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:ondrej/php \
 && apt-get update

RUN apt-get install -y \
    apache2 \
    php7.1 php7.1-xml php7.1-mysql php7.1-json php7.1-mcrypt php7.1-mbstring php7.1-ldap php7.1-soap php7.1-zip php7.1-gd \
    graphviz curl \
    git wget unzip

RUN if [ "$NO_DATABASE" = false ]; then apt-get install -y mariadb-server pwgen ; fi
# Remove pre-installed database and apache demo data
RUN rm -rf /var/lib/mysql/* /var/www/html/*

# Copy configs and scripts
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

RUN chmod +x /*.sh
# Create shortcuts for the right management scripts
RUN ln -s /make-itop-config-writable.sh /usr/local/bin/conf-w
RUN ln -s /make-itop-config-read-only.sh /usr/local/bin/conf-ro

# Get iTop
RUN mkdir -p /tmp/itop
RUN wget --no-check-certificate -O /tmp/itop/itop.zip https://sourceforge.net/projects/itop/files/itop/2.6.0-beta/iTop-2.6-beta-4146.zip
RUN unzip /tmp/itop/itop.zip -d /tmp/itop/
RUN mv /tmp/itop/web/* /var/www/html

# Get latest Russian translations
RUN /update-russian-translations.sh

RUN chown -R www-data:www-data /var/www/html

COPY service /etc/service/
RUN chmod +x -R /etc/service

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /var/lib/mysql

EXPOSE 80
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/run.sh"]
