FROM debian:bullseye

ENV PATH="/root/.cargo/bin:/root/.pixi/bin:${PATH}"

# Update and install common dependencies
RUN apt-get update && apt-get install -y \
    curl build-essential git wget gnupg apt-transport-https software-properties-common

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y\
    && /root/.cargo/bin/rustup install nightly \
    && /root/.cargo/bin/rustup default stable \
    && /root/.cargo/bin/rustup component add rustfmt clippy \
    && cargo +stable install cargo-llvm-cov \
    && cargo +stable install cargo-machete \
    && cargo +stable install cargo-nextest --locked \
    && cargo +nightly install cargo-llvm-cov \
    && cargo +nightly install cargo-machete \
    && cargo +nightly install cargo-nextest --locked

# Install Microsoft packages (PowerShell)
RUN wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*

# Install Pixi
RUN curl -fsSL https://pixi.sh/install.sh | sh
