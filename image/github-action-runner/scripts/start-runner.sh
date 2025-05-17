#!/bin/bash
if [$USE_PROXY]; then \
    export HTTP_PROXY = "http://host.docker.internal:10808" && \
    export HTTPS_PROXY = "http://host.docker.internal:10808" && \
    export http_proxy = "http://host.docker.internal:10808" && \
    export https_proxy = "http://host.docker.internal:10808" && \
    export NO_PROXY = "localhost,127.0.0.1,host.docker.internal" && \
    git config --global http.proxy 'http://host.docker.internal:10808' && \
    git config --global https.proxy 'http://host.docker.internal:10808'; \
fi

GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
GH_TOKEN=$GH_TOKEN

RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 5 | head -n 1)
RUNNER_NAME="dockerNode-${RUNNER_SUFFIX}"

REG_TOKEN=$(curl -sX POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${GH_TOKEN}" https://api.github.com/repos/${GH_OWNER}/${GH_REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

cd /home/runner/actions-runner

./config.sh --unattended --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} --token ${REG_TOKEN} --name ${RUNNER_NAME}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!