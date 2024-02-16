# base image
FROM ubuntu:20.04

# Input GitHub runner version argument
ARG RUNNER_VERSION
ARG DOCKER_GID
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt to use the host's apt-cacher-ng proxy
RUN echo 'Acquire::http::Proxy "http://127.0.0.1:3142";' > /etc/apt/apt.conf.d/01proxy
# HTTPS bypass for docker repos (will fail if some domains are not covered)
# RUN echo 'Acquire::HTTPS::Proxy::download.docker.com "DIRECT";' >> /etc/apt/apt.conf.d/01proxy

# Update and install necessary tools
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y curl gpg lsb-release sudo git rsync git-lfs

# Install git-filter-repo with a shallow clone
RUN git clone --depth 1 https://github.com/newren/git-filter-repo.git /tmp/git-filter-repo && \
    cp /tmp/git-filter-repo/git-filter-repo /usr/local/bin/ && \
    chmod +x /usr/local/bin/git-filter-repo && \
    rm -rf /tmp/git-filter-repo

# Add Microsoft repository key and Azure CLI repository
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main" > \
    /etc/apt/sources.list.d/azure-cli.list

# Update and install packages including openssh-client
RUN apt-get install -y --no-install-recommends wget unzip vim
RUN apt-get install -y --no-install-recommends azure-cli jq
RUN apt-get install -y --no-install-recommends build-essential libssl-dev libffi-dev
RUN apt-get install -y --no-install-recommends python3 python3-venv python3-dev python3-pip openssh-client

# Add a non-sudo user
RUN useradd -m docker

# Find out the Docker group ID from the host and create a docker group with the same ID in the container
RUN groupadd -g ${DOCKER_GID} dockerhost
RUN usermod -aG dockerhost docker

# Install Docker CLI
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli

# Add external downloads
COPY ./downloaded_files/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz /home/docker/actions-runner/

# Download the GitHub Actions runner only if it's not already present
RUN if [ ! -f "/home/docker/actions-runner/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" ]; then \
    curl -o "/home/docker/actions-runner/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"; \
    fi

# Unzip the GitHub Actions runner
RUN cd /home/docker/actions-runner && \
    tar xzf "./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# add over the start.sh script
ADD scripts/start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
