FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# 安装依赖
RUN apt-get update && \
    apt-get install -y libayatana-appindicator3-dev libkeybinder-3.0-dev wget curl && \
    rm -rf /var/lib/apt/lists/*

# 下载并安装 FlClash 最新 linux-arm64.deb 包
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

# 创建启动脚本，假设flclash的命令为 FlClash（如有不同请调整）
RUN echo '#!/bin/sh\nexec FlClash' > /startapp.sh && chmod +x /startapp.sh

ENV APP_RUN=/startapp.sh

EXPOSE 5800 5900 7890/tcp 1053/udp
