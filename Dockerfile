# Download base image
FROM debian:stretch

# Define the ARG variables for creating docker image
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

# Labels
LABEL org.label-schema.name = "LogitechMediaServer" \
      org.label-schema.description = "Debian based Logitech Media Server Docker image" \
      org.label-schema.vendor = "Paul NOBECOURT <paul.nobecourt@orange.fr>" \
      org.label-schema.url = "https://github.com/pnobecourt/" \
      org.label-schema.version = $VERSION \
      org.label-schema.build-date = $BUILD_DATE \
      org.label-schema.vcs-url = "https://github.com/pnobecourt/docker-logitechmediaserver" \
      org.label-schema.vcs-ref = $VCS_REF \
      org.label-schema.schema-version = "1.0"

# Define the ENV variable for creating docker image
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE_VERSION_URL=http://www.mysqueezebox.com/update/?version=7.9.1&revision=1&geturl=1&os=deb

# Install additional repositories
RUN echo "deb http://www.deb-multimedia.org stretch main non-free" | tee -a /etc/apt/sources.list.d/debian-multimedia.list && \
    apt-get update ; \
    apt-get install -y --allow-unauthenticated deb-multimedia-keyring && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

# Install supervisor and copy it's configuration file
RUN apt-get update && \
    apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install LogitechMediaServer_DEPENDENCIES
RUN apt-get update && \
    apt-get install -y \
                    curl \
                    faac \
                    faad \
                    ffmpeg \
                    flac \
                    lame \
                    libcrypt-openssl-rsa-perl \
                    libio-socket-inet6-perl \
                    libio-socket-ssl-perl \
                    libwww-perl \ 
                    locales \
                    perl \
                    sox \
                    wavpack \
                    wget \
                    && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

# Install LogitechMediaServer
RUN url=$(curl "$PACKAGE_VERSION_URL" | sed 's/_all\.deb/_amd64\.deb/') && \
    curl -Lsf -o /tmp/logitechmediaserver.deb $url && \
    dpkg -i /tmp/logitechmediaserver.deb && \
    apt-get -f -y install && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

# Volumes
VOLUME ["/srv/squeezebox/prefs","/srv/squeezebox/logs","/srv/squeezebox/cache","/var/log/supervisor"]
    
# Ports configuration
EXPOSE 3483 3483/udp 5353 5353/udp 9000 9005 9010 9090

# Start PGM
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
