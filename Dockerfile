# Download base image
FROM debian:stretch

# Define the ARG variables for creating docker image
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

# Labels
LABEL org.label-schema.name="LogitechMediaServer" \
      org.label-schema.description="Debian based Logitech Media Server Docker image" \
      org.label-schema.vendor="Paul NOBECOURT <paul.nobecourt@orange.fr>" \
      org.label-schema.url="https://github.com/pnobecourt/" \
      org.label-schema.version=$VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/pnobecourt/docker-logitechmediaserver" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0"

# Define the ENV variable for creating docker image
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL=/bin/bash
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PACKAGE_VERSION_URL=http://www.mysqueezebox.com/update/?version=7.9.1&revision=1&geturl=1&os=deb
ENV SQUEEZE_VOL=/srv/squeezebox

# Install additional repositories
RUN echo "deb http://www.deb-multimedia.org stretch main non-free" | tee -a /etc/apt/sources.list.d/debian-multimedia.list && \
    apt-get update ; \
    apt-get install -y --allow-unauthenticated deb-multimedia-keyring && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

# Install gosu, supervisor and copy supervisor's configuration file
RUN apt-get update && \
    apt-get install -y gosu supervisor && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*
COPY supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord/squeezeboxserver.conf /etc/supervisor/conf.d/squeezeboxserver.conf

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
                    libmoosex-role-timer-perl \
                    libwww-perl \ 
                    locales \
                    perl \
                    perl-base \
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
    userdel squeezeboxserver && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

# Ports configuration
EXPOSE 3483 3483/udp 5353 5353/udp 9000 9005 9010 9090

# Start PGM
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
