#!/bin/sh
set -e

apt-get update
# Update and install common dependencies
apt-get install -y --no-install-recommends \
    aria2 \
    build-essential \
    curl \
    git \
    jq \
    libssl-dev \
    libffi-dev \
    libsqlite3-dev \
    libtool \
    p7zip-full \
    p7zip-rar \
    pkg-config \
    software-properties-common \
    unzip \
    wget

# install pwsh
wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell

# install rust
curl https://sh.rustup.rs -sSf | bash -s -- -y \
    && /root/.cargo/bin/rustup install nightly \
    && /root/.cargo/bin/rustup default stable \
    && /root/.cargo/bin/rustup component add rustfmt clippy

apt-get clean
