FROM mcr.microsoft.com/azure-cli:2.0.73

ENTRYPOINT ["/bin/bash"]
CMD ["/setup.sh"]

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/

# helm
RUN apk --no-cache update && \
    apk --no-cache add jq openssl && \ 
    curl -L https://git.io/get_helm.sh | sh

# compose-on-kubernetes installer
RUN curl -LO https://github.com/docker/compose-on-kubernetes/releases/download/v0.4.23/installer-linux && \
    chmod +x ./installer-linux && \
    mv ./installer-linux /usr/local/bin/

COPY compose-etcd.yaml /
COPY setup.sh /