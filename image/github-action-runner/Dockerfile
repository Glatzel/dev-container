FROM ubuntu:latest
ARG RUNNER_VERSION
ENV PATH="/root/.cargo/bin:/root/.pixi/bin:${PATH}"

# Update and install common dependencies
COPY ../common/install-deps.sh /tmp/install-deps.sh
RUN chmod +x /tmp/install-deps.sh && /tmp/install-deps.sh

# GitHub Actions Runner Installation 
RUN useradd -m runner && \
      cd /home/runner && mkdir actions-runner && cd actions-runner && \
      curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
      tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
    
# install some additional dependencies
RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

# Add and make the start script executable
ADD scripts/start-runner.sh start-runner.sh

# make the script executable
RUN chmod +x start-runner.sh; 

# Clean up APT cache
RUN rm -rf /var/lib/apt/lists/*

USER runner

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start-runner.sh"]

