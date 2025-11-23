# Use Docker-in-Docker (DinD)
FROM docker:24-dind

ENV DOCKER_TLS_CERTDIR=/certs

# Install dependencies
RUN apk add --no-cache curl bash git

# Install k3d
RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Helm
RUN curl -fsSL https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz -o helm.tar.gz \
    && tar -zxvf helm.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 helm.tar.gz

# Copy start-cluster script
COPY start-cluster.sh /start-cluster.sh
RUN chmod +x /start-cluster.sh

# Copy wiki-service and wiki-chart directories
COPY wiki-service /wiki-service
COPY wiki-chart /wiki-chart

# Expose ports for services
EXPOSE 8080
EXPOSE 6443


ENTRYPOINT ["/start-cluster.sh"]
