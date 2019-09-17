FROM mcr.microsoft.com/azure-cli:2.0.73

ENTRYPOINT ["/bin/bash"]
CMD ["/setup.sh"]

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/

# Docker - 19.x
RUN apk --no-cache update && \
    apk --no-cache add docker --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    rm -rf /var/cache/apk/*

COPY setup.sh /