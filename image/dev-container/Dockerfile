FROM ubuntu:latest
ARG RUNNER_VERSION
ENV PATH="/root/.cargo/bin:/root/.pixi/bin:${PATH}"

# Update and install common dependencies
COPY ../common/install-deps.sh /tmp/install-deps.sh
RUN chmod +x /tmp/install-deps.sh && /tmp/install-deps.sh

# Install Pixi
RUN curl -fsSL https://pixi.sh/install.sh | sh
COPY ./config/pixi-global.toml /root/.pixi/manifests/pixi-global.toml

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*
