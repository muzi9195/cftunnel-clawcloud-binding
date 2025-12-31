FROM xream/sub-store:2.20.40-http-meta

# 声明架构参数
ARG TARGETARCH
ENV DOCKER_ARCH=${TARGETARCH}

# TUNNEL_TOKEN 参数（构建时传入）
ARG TUNNEL_TOKEN=""
ENV TUNNEL_TOKEN=${TUNNEL_TOKEN}

# 复制我们的 wrapper 脚本
COPY my_wrapper.sh /usr/local/bin/my_wrapper.sh

# 安装 cloudflared 并替换 entrypoint
RUN echo "Building for architecture: ${TARGETARCH}" && \
    curl -fsSL --connect-timeout 10 --max-time 60 --retry 3 \
    "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${TARGETARCH}" \
    -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared && \
    cloudflared --version && \
    mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-origin.sh && \
    mv /usr/local/bin/my_wrapper.sh /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh
