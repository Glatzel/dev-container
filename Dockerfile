FROM debian:bullseye

ENV PATH="/root/.cargo/bin:/root/.pixi/bin:${PATH}"

# Update and install common dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    aria2 \
    build-essential \
    curl \
    git \
    gnupg \
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
COPY ./pixi-global.toml ~/.pixi/manifests/pixi-global.toml
RUN pixi global update
