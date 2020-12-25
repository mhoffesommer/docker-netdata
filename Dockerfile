FROM alpine:3.5
MAINTAINER Martin Hoffesommer <3dcoder@gmail.com>

ENV S6VERSION 1.17.2.0
ENV PHPSERVERMON_VERSION 3.2.0
ENV MYSQL_DATABASE "monitor"
ENV MYSQL_USER "user"
ENV MYSQL_PASSWORD "password"

RUN apk add --update \
    wget \
    ca-certificates \
    openssh \
    nginx \
    php5-fpm \  
    php5-json \
    php5-zlib \
    php5-bz2 \
    php5-xml \
    php5-phar \
    php5-openssl \
    php5-mcrypt \
    php5-pdo \
    php5-mysql \
    #php5-ctype \
    #php5-opcache \
    #php5-memcache \
    php5-curl \
    #su-exec \
    #openssl-dev \
    bash \
	mariadb \
	mariadb-client \
	pwgen \
 && rm -r /var/www \
	\
    # Install composer \
 && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/sbin --filename=composer \
 && php -r "unlink('composer-setup.php');" \
	\
	# Install S6 \
 && wget https://github.com/just-containers/s6-overlay/releases/download/v${S6VERSION}/s6-overlay-amd64.tar.gz -O /tmp/s6-overlay.tar.gz \
 && tar xvfz /tmp/s6-overlay.tar.gz -C / \
 && rm -f /tmp/s6-overlay.tar.gz \
	\
	# PHPServerMon \
 && wget https://github.com/phpservermon/phpservermon/releases/download/v${PHPSERVERMON_VERSION}/phpservermon-${PHPSERVERMON_VERSION}.tar.gz -O /tmp/mon.tar.gz \
 && mkdir -p /var/www \
 && tar xvfz /tmp/mon.tar.gz -C /var/www \
 && mv /var/www/phpservermon-${PHPSERVERMON_VERSION} /var/www/web \
 && rm -f /tmp/mon.tar.gz \
	\
 && apk del wget \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/*

COPY rootfs /

# configure monitor
RUN echo "<?php" > /var/www/web/config.php \
 && echo "define('PSM_DB_PREFIX','monitor_');" >> /var/www/web/config.php \
 && echo "define('PSM_DB_USER','${MYSQL_USER}');" >> /var/www/web/config.php \
 && echo "define('PSM_DB_PASS','${MYSQL_PASSWORD}');" >> /var/www/web/config.php \
 && echo "define('PSM_DB_NAME','${MYSQL_DATABASE}');" >> /var/www/web/config.php \
 && echo "define('PSM_DB_HOST','localhost');" >> /var/www/web/config.php \
 && echo "define('PSM_DB_PORT','3306');" >> /var/www/web/config.php \
 && echo "define('PSM_BASE_URL','');" >> /var/www/web/config.php \
 && chown -R nginx:www-data /var/www
#RUN /bin/bash /etc/services.d/mariadb/run \
# && php /var/www/web/install.php
 
EXPOSE 80
ENTRYPOINT [ "/init" ]


# /var/www (/web)
# /var/lib/mysql


# environment
#ENV SCM_VERSION 1.54
#ENV SCM_PKG_URL https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/${SCM_VERSION}/scm-server-${SCM_VERSION}-app.tar.gz
#ENV SCM_HOME /var/lib/scm

#RUN apk add --update curl mercurial \
# && rm -rf /var/cache/apk/*
	
#RUN mkdir -p /opt && curl -Lks "$SCM_PKG_URL" | tar -zxC /opt \
# && adduser -D -h /opt/scm-server -s /bin/bash scm \
# && chown -R scm:scm /opt/scm-server \
# && chmod +x /opt/scm-server/bin/scm-server \
# && mkdir -p $SCM_HOME \
# && chown -R scm:scm $SCM_HOME
 
#WORKDIR $SCM_HOME
#VOLUME $SCM_HOME
#EXPOSE 8080

#COPY ./docker-entrypoint.sh /
#COPY ./users.xml.template /opt/scm-server/

#RUN chmod +x /docker-entrypoint.sh

#USER scm
#ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD ["/opt/scm-server/bin/scm-server"]


# MySQL
# MySQL backup
