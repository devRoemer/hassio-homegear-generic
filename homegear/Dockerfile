ARG BUILD_FROM=homeassistant/amd64-base-debian:bullseye

FROM $BUILD_FROM

RUN touch /tmp/HOMEGEAR_STATIC_INSTALLATION; \
    touch /.dockerenv;

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-transport-https \
        wget \
        ca-certificates \
        apt-utils \
        gnupg \
        libzip4 \
        libavahi-client3 \
        libavahi-client-dev \
        insserv \
        locales \
        lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8

RUN curl -fsSL https://apt.homegear.eu/Release.key | gpg --dearmor -o /usr/share/keyrings/homegear-archive-keyring.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/homegear-archive-keyring.gpg] https://apt.homegear.eu/debian/bullseye/homegear/stable/ bullseye main' > /etc/apt/sources.list.d/homegear.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        libhomegear-node \
        homegear \
        homegear-management \
        homegear-adminui \
        homegear-nodes-core \
        homegear-nodes-extra \
        homegear-homematicbidcos \
        homegear-homematicwired \
        homegear-insteon \
        homegear-max \
        homegear-philipshue \
        homegear-sonos \
        homegear-kodi \
        homegear-ipcam \
        homegear-beckhoff \
        homegear-knx \
        homegear-enocean \
        homegear-intertechno \
        homegear-nanoleaf \
        homegear-ccu \
        homegear-mbus \
        homegear-influxdb \
        homegear-rsl \
        homegear-rs2w \
        homegear-zwave \
        homegear-zigbee \
        homegear-easyled \
        homegear-easyled2 \
        homegear-easycam \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /tmp/* /var/tmp/*

RUN rm -f /etc/homegear/dh1024.pem \
    && rm -f /etc/homegear/homegear.crt \
    && rm -f /etc/homegear/homegear.key \
    && cp -R /etc/homegear /etc/homegear.config \
    && cp -R /var/lib/homegear /var/lib/homegear.data

COPY rootfs/start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/bin/bash", "-c", "/start.sh"]

EXPOSE 2001 2002 2003

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="devRoemer" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="devRoemer" \
    org.opencontainers.image.authors="devRoemer" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/devRoemer/hassio-homegear-generic" \
    org.opencontainers.image.source="https://github.com/devRoemer/hassio-homegear-generic" \
    org.opencontainers.image.documentation="https://github.com/devRoemer/hassio-homegear-generic/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
