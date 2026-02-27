ARG IDF_TAG
ARG LLVM_TAG

FROM ghcr.io/sivakov512/esp-idf:${IDF_TAG}-llvm${LLVM_TAG}
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    # Install all required stuff
    apt-get install -y --no-install-recommends \
    git \
    gcc \
    g++ \
    pkg-config \
    cmake \
    curl \
    libssl-dev \
    libdbus-1-dev \
    libglib2.0-dev \
    libavahi-client-dev \
    ninja-build \
    python3-venv \
    python3-dev \
    python3-pip \
    unzip \
    libgirepository1.0-dev \
    libcairo2-dev \
    libreadline-dev \
    libevent-dev && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /usr/share/doc/* \
    /usr/share/man/* \
    /usr/share/locale/* \
    /usr/share/info/* \
    /var/log/* \
    /var/cache/* \
    /tmp/* \
    /root/.cache

ARG GIT_CLONE_REF
ARG GIT_CLONE_URL=https://github.com/espressif/esp-matter.git
ARG GIT_CLONE_PATH=${IDF_TOOLS_PATH}/esp-matter

RUN \
    # Checkout ESP Matter
    git init "${GIT_CLONE_PATH}" && \
    cd "${GIT_CLONE_PATH}" && \
    git remote add origin "${GIT_CLONE_URL}" && \
    git fetch --depth 1 origin "${GIT_CLONE_REF}" && \
    git checkout "${GIT_CLONE_REF}" && \
    git submodule update --init --depth 1 --jobs $(nproc) && \
    cd ${GIT_CLONE_PATH}/connectedhomeip/connectedhomeip && \
    ./scripts/checkout_submodules.py --platform esp32 linux --shallow --jobs $(nproc) && \
    # Perform install
    . ${ESP_IDF_INSTALLATION_PATH}/export.sh && \
    cd ${GIT_CLONE_PATH} && \
    ./install.sh --no-host-tool && \
    # Cleanup
    rm -rf ${GIT_CLONE_PATH}/.git \
    ${GIT_CLONE_PATH}/docs \
    ${GIT_CLONE_PATH}/examples \
    /tmp/* \
    /root/.cache \
    /root/.cipd-cache-dir

ENV ESP_MATTER_INSTALLATION_PATH=${GIT_CLONE_PATH}

COPY --chmod=755 entrypoint.sh ${IDF_TOOLS_PATH}/entrypoint.sh
ENTRYPOINT ["/opt/esp/entrypoint.sh"]
