FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# INSTALL DEPENDENCES
RUN apt-get update && \
    apt-get install -y \
      locales \
      dbus \
      libayatana-appindicator3-dev \
      libkeybinder-3.0-dev \
      wget \
      curl \
      fonts-noto-cjk \
      fonts-wqy-zenhei \
      fonts-wqy-microhei && \
    locale-gen zh_CN.UTF-8 en_US.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# Download latest FlClash pacakge (linux-amd64.deb)
RUN set -ex; \
    url=$(curl -s https://api.github.com/repos/chen08209/FlClash/releases/latest \
      | grep browser_download_url \
      | grep 'linux-amd64\.deb"' \
      | cut -d '"' -f 4); \
    echo "Downloading $url"; \
    wget -O /tmp/flclash.deb "$url"; \
    apt-get update; \
    apt-get install -y /tmp/flclash.deb || apt-get install -fy; \
    rm /tmp/flclash.deb; \
    rm -rf /var/lib/apt/lists/*

# Create start-up script
RUN echo '#!/bin/sh\n\
exec FlClash\n' > /startapp.sh && chmod +x /startapp.sh

ENV APP_NAME=flclash
ENV APP_RUN=/startapp.sh

# Expose GUI、Clash proxies and DNS ports
EXPOSE 5800 5900 7890/tcp 1053/udp
