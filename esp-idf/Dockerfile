ARG LLVM_TAG
FROM ghcr.io/sivakov512/llvm:${LLVM_TAG}
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    # Install all required stuff
    apt-get install -y --no-install-recommends \
    git \
    wget \
    flex \
    bison \
    gperf \
    python3 \
    python3-pip \
    python3-venv \
    cmake \
    ninja-build \
    ccache \
    libffi-dev \
    libssl-dev \
    dfu-util \
    libusb-1.0-0 && \
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

ENV IDF_TOOLS_PATH=/opt/esp

ARG GIT_CLONE_REF
ARG GIT_CLONE_URL=https://github.com/espressif/esp-idf.git
ARG GIT_CLONE_PATH=${IDF_TOOLS_PATH}/esp-idf

RUN git init "${GIT_CLONE_PATH}" && \
    cd "${GIT_CLONE_PATH}" && \
    git remote add origin "${GIT_CLONE_URL}" && \
    git fetch --depth 1 origin "${GIT_CLONE_REF}" && \
    git checkout "${GIT_CLONE_REF}" && \
    git submodule update --init --recursive --depth 1 --jobs $(nproc) && \
    rm -rf ${GIT_CLONE_PATH}/.git \
    ${GIT_CLONE_PATH}/docs \
    ${GIT_CLONE_PATH}/examples

RUN cd "${GIT_CLONE_PATH}" && \
    ./install.sh all && \
    rm -rf ${IDF_TOOLS_PATH}/dist /tmp/* /root/.cache

ENV ESP_IDF_INSTALLATION_PATH=${GIT_CLONE_PATH}

COPY --chmod=755 entrypoint.sh ${IDF_TOOLS_PATH}/entrypoint.sh
ENTRYPOINT ["/opt/esp/entrypoint.sh"]
