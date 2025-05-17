FROM ubuntu:latest
ARG RUNNER_VERSION
ENV PATH="/root/.cargo/bin:/root/.pixi/bin:${PATH}"

# Update and install common dependencies
RUN apt-get update && apt-get install -y \
    aria2 \
    build-essential \
    curl \
    git \
    jq \
    libsqlite3-dev \
    libtool \
    p7zip-full \
    p7zip-rar \
    pkg-config \
    software-properties-common \
    wget

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y\
    && /root/.cargo/bin/rustup install nightly \
    && /root/.cargo/bin/rustup default stable \
    && /root/.cargo/bin/rustup component add rustfmt clippy

# Install Microsoft packages (PowerShell)
RUN wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*

# Install Pixi and global tools
RUN curl -fsSL https://pixi.sh/install.sh | sh
COPY ./pixi-global.toml /root/.pixi/manifests/pixi-global.toml

# github action runner==================================================================================================
RUN if [ -n "$RUNNER_VERSION" ]; then \
        mkdir /actions-runner && cd /actions-runner && \
        && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz &&\
        && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz; `
        fi

# install some additional dependencies
RUN if [ -n "$RUNNER_VERSION" ]; then \
      /actions-runner/bin/installdependencies.sh; \
    fi

# add over the start.sh script
ADD scripts/start-runner.sh /start-runner.sh

# make the script executable
RUN chmod +x /start-runner.sh
