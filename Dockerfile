# Base Image
FROM amazonlinux:2018.03
CMD ["/bin/bash"]

# Maintainer
MAINTAINER ProcessMaker CloudOps <cloudops@processmaker.com>

# Extra
LABEL version="3.5.6"
LABEL description="ProcessMaker 3.5.6 Docker Container - Apache"

# Declare ARG and ENV Variables
ARG URL
ENV URL $URL

# Initial steps
RUN yum clean all && yum install epel-release -y && yum update -y
RUN cp /etc/hosts ~/hosts.new && sed -i "/127.0.0.1/c\127.0.0.1 localhost localhost.localdomain `hostname`" ~/hosts.new && cp -f ~/hosts.new /etc/hosts

# Required packages
RUN yum install \
  gcc \
  wget \
  nano \
  sendmail \
  libmcrypt-devel \
  httpd24 \
  mysql57 \
  php73 \
  php73-devel \
  php73-opcache \
  php73-gd \
  php73-mysqlnd \
  php73-soap \
  php73-mbstring \
  php73-ldap \
  php7-pear \
  -y

RUN echo '' | pecl7 install mcrypt
  
# Download ProcessMaker Enterprise Edition
RUN wget -O "/tmp/processmaker-3.5.6.tar.gz" \
      "https://artifacts.processmaker.net/official/processmaker-3.5.6.tar.gz"
	  
# Copy configuration files
COPY pmos.conf /etc/httpd/conf.d
RUN mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bk
COPY httpd.conf /etc/httpd/conf

# Apache Ports
EXPOSE 80

# Docker entrypoint
COPY docker-entrypoint.sh /bin/
RUN chmod a+x /bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]