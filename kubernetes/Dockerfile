FROM openjdk:8
#FROM java:8
MAINTAINER Cristian Molaro cristian@molaro.be

# Set Environment Variables
ENV     PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data-integration \
        KETTLE_HOME=/data-integration

# PDI
COPY ./data-integration /data-integration

# Working directories
RUN mkdir /jobs

# Adapt timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
