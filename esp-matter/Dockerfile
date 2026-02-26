ARG IDF_TAG=latest
ARG LLVM_VERSION=19
FROM ghcr.io/sivakov512/esp-idf:${IDF_TAG}-llvm${LLVM_VERSION}

ENV ESP_MATTER_CLONE_URL=https://github.com/espressif/esp-matter.git
ENV ESP_MATTER_CLONE_PATH=/opt/esp/esp-matter
ENV ESP_ENTRYPOINT_FILE=/opt/esp/entrypoint.sh

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git gcc g++ pkg-config cmake curl libssl-dev libdbus-1-dev \
    libglib2.0-dev libavahi-client-dev ninja-build python3-venv python3-dev \
    python3-pip unzip libgirepository1.0-dev libcairo2-dev libreadline-dev \
    libevent-dev default-jre && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG ESP_MATTER_SHA
RUN \
    # Clone ESP Matter repo
    git init "${ESP_MATTER_CLONE_PATH}" && \
    cd "${ESP_MATTER_CLONE_PATH}" && \
    git remote add origin "${ESP_MATTER_CLONE_URL}" && \
    git fetch --depth 1 origin "${ESP_MATTER_SHA}" && \
    git checkout "${ESP_MATTER_SHA}" && \
    # Activate ESP-IDF environment
    export IDF_PATH_FORCE=1 && \
    . "${ESP_ENTRYPOINT_FILE}" && \
    # Checkout ESP Matter submodules
    git submodule update --init --depth 1 --jobs $(nproc) && \
    cd ./connectedhomeip/connectedhomeip && \
    ./scripts/checkout_submodules.py --platform esp32 linux --shallow --jobs $(nproc) && \
    # Install ESP Matter
    cd "${ESP_MATTER_CLONE_PATH}" && \
    ./install.sh --no-host-tool && \
    # Clean cache
    rm -rf /root/.cache /tmp/*

COPY --chmod=755 entrypoint.sh ${ESP_ENTRYPOINT_FILE}
