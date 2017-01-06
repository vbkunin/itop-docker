FROM tutum/lamp:latest
MAINTAINER Vladimir Kunin <vladimir@itop-itsm.ru>

# Install additional packages
RUN apt-get update && \
  apt-get -y install php5-mcrypt php5-gd php5-ldap php5-cli php-soap php5-json php5-imap graphviz wget unzip
RUN php5enmod mcrypt ldap gd imap

# Copy cron config and scripts
COPY artifacts/supervisord-cron.conf /etc/supervisor/conf.d/supervisord-cron.conf
COPY artifacts/start-cron.sh /start-cron.sh
COPY artifacts/setup-itop-cron.sh /setup-itop-cron.sh
COPY artifacts/itop-cron.logrotate /etc/logrotate.d/itop-cron

# Copy update Russian translations script
COPY artifacts/update-russian-translations.sh /update-russian-translations.sh

# Copy Portal Announcement Extension install script
COPY artifacts/install-portal-announcement.sh /install-portal-announcement.sh
COPY artifacts/update-portal-announcement.sh /update-portal-announcement.sh

# Copy iTop config-file rights management scripts
COPY artifacts/make-itop-config-writable.sh /make-itop-config-writable.sh
COPY artifacts/make-itop-config-read-only.sh /make-itop-config-read-only.sh

# Copy Tookit installation script
COPY artifacts/install-toolkit.sh /install-toolkit.sh

RUN chmod 755 /*.sh

# Get iTop 2.3.1
RUN mkdir -p /tmp/itop
RUN wget -O /tmp/itop/itop.zip https://sourceforge.net/projects/itop/files/itop/2.3.1/iTop-2.3.1-2832.zip
RUN unzip /tmp/itop/itop.zip -d /tmp/itop/

# Configure /app folder with iTop
RUN rm -fr /app
RUN mkdir -p /app && cp -r /tmp/itop/web/* /app && rm -rf /tmp/itop

# Get latest Russian translations
RUN /update-russian-translations.sh

RUN chown -R www-data:www-data /app

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 8M
ENV PHP_POST_MAX_SIZE 10M

EXPOSE 80 3306
CMD ["/run.sh"]
