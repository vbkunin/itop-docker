FROM tutum/lamp:latest
MAINTAINER Vladimir Kunin <vladimir@itop-itsm.ru>

# Install additional packages
RUN apt-get update && \
  apt-get -y install php5-mcrypt php5-gd php5-ldap php5-cli php-soap php5-json graphviz wget unzip
RUN php5enmod mcrypt ldap gd

# Add update Russian translations script
ADD update-russian-translations.sh /update-russian-translations.sh
ADD make-itop-config-writable.sh /make-itop-config-writable.sh
ADD make-itop-config-read-only.sh /make-itop-config-read-only.sh
RUN chmod 755 /*.sh

# Get iTop 2.2.0-beta
RUN mkdir -p /tmp/itop
RUN wget -O /tmp/itop/itop.zip http://downloads.sourceforge.net/project/itop/itop/2.2.0-beta/iTop-2.2.0-beta-2371.zip
RUN unzip /tmp/itop/itop.zip -d /tmp/itop/

# Configure /app folder with iTop
RUN rm -fr /app
RUN mkdir -p /app && cp -r /tmp/itop/web/* /app && rm -rf /tmp/itop
#RUN mkdir -p /app/conf /app/logs /app/data

# Get latest Russian translations
RUN /update-russian-translations.sh

RUN chown -R www-data:www-data /app

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 8M
ENV PHP_POST_MAX_SIZE 10M

EXPOSE 80 3306
CMD ["/run.sh"]