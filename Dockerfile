FROM debian:stable

MAINTAINER Remi Suinot <remi@suinot.org>

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

RUN apt-get update && apt-get install -y \
    libmime-base64-perl \
    locales \
    netcat

RUN echo "locales locales/default_environment_locale select fr_FR.UTF-8" | debconf-set-selections \
    && echo "locales locales/locales_to_be_generated multiselect 'fr_FR.UTF-8 UTF-8'" | debconf-set-selections \
    && echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata && locale-gen --purge en_US.UTF-8  \
    && rm -rf /var/lib/apt/lists/*

COPY ./01proxy  /etc/apt/apt.conf.d/01proxy
COPY ./detect_proxy.sh /etc/apt

RUN apt update -y && \ 
    apt upgrade -y && \
    apt install -y --no-install-recommends --no-install-suggests \
    bind9 \
    rng-tools \
    cron \
    vim

RUN mkdir -p /var/run/named /etc/bind/zones && \
    chmod 775 /var/run/named && \
    chown root:bind /var/run/named > /dev/nul 2>&1 
RUN apt-get clean && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* \
    rm -rf /tmp/* \
    rm -rf /var/tmp/* \
    rm -rf /usr/share/man/??_* \
    rm -rf /usr/share/man/?? 


EXPOSE 53/TCP 
EXPOSE 53/UDP 

COPY zonesigner.sh /usr/local/bin/zonesigner.sh
COPY creation.sh /usr/local/bin/creation.sh
CMD ["/usr/local/bin/creation.sh"]
