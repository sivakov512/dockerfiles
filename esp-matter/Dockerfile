# ESP-Matter SDK on top of our esp-idf image, which brings ESP-IDF and
# Espressif LLVM (clang-tidy, clang-format). Built from source rather than on
# the official espressif/esp-matter image: that one is about 6 GB compressed
# and does not fit next to a job on a private-repo GitHub runner.
ARG BASE_IMAGE=ghcr.io/sivakov512/esp-idf
ARG IDF_TAG=v6.0.2
FROM ${BASE_IMAGE}:${IDF_TAG}
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libavahi-client-dev \
    libcairo2-dev \
    libdbus-1-dev \
    libevent-dev \
    libgirepository1.0-dev \
    libglib2.0-dev \
    libreadline-dev \
    pkg-config \
    python3-dev \
    unzip && \
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

ARG ESP_MATTER_REF
ARG ESP_MATTER_CLONE_URL=https://github.com/espressif/esp-matter.git
ENV ESP_MATTER_PATH=${IDF_TOOLS_PATH}/esp-matter

# Shallow clones and only the connectedhomeip submodules for esp32 (host tools
# are not built), then without .git and docs. Examples stay: projects use
# examples/common from esp-matter and examples/platform/esp32 from
# connectedhomeip. Of the CIPD packages the connectedhomeip bootstrap fetches,
# the ESP32 build needs only gn and zap: the ARM GCC toolchain and pigweed's
# LLVM, QEMU and sysroots (about 4 GB) go.
RUN git init "${ESP_MATTER_PATH}" && \
    cd "${ESP_MATTER_PATH}" && \
    git remote add origin "${ESP_MATTER_CLONE_URL}" && \
    git fetch --depth 1 origin "${ESP_MATTER_REF}" && \
    git checkout FETCH_HEAD && \
    git submodule update --init --depth 1 --jobs $(nproc) && \
    cd connectedhomeip/connectedhomeip && \
    ./scripts/checkout_submodules.py --platform esp32 --shallow && \
    . "${IDF_TOOLS_PATH}/esp-idf/export.sh" && \
    cd "${ESP_MATTER_PATH}" && \
    ./install.sh --no-host-tool && \
    CIPD="${ESP_MATTER_PATH}/connectedhomeip/connectedhomeip/.environment/cipd/packages" && \
    rm -rf "${CIPD}/arm" && \
    cd "${CIPD}/pigweed" && \
    find bin -mindepth 1 ! -name ninja ! -name protoc ! -name make -exec rm -rf {} + && \
    rm -rf lib clang_sysroot share openocd libexec include && \
    find "${ESP_MATTER_PATH}" -name .git -prune -exec rm -rf {} + && \
    rm -rf "${ESP_MATTER_PATH}/docs" \
    "${ESP_MATTER_PATH}/connectedhomeip/connectedhomeip/docs" \
    /tmp/* \
    /root/.cache \
    /root/.cipd-cache-dir

COPY --chmod=755 entrypoint.sh ${IDF_TOOLS_PATH}/entrypoint.sh
CMD ["/bin/bash"]
