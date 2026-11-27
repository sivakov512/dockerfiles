# ESP-IDF with all toolchains plus Espressif LLVM for clang-tidy and clang-format.
# Built from source rather than on the official espressif/idf image: that one
# carries the full IDF git clone with docs and examples (2.4 GB compressed)
# and does not fit next to a job on a private-repo GitHub runner.
FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    bison \
    ca-certificates \
    ccache \
    cmake \
    curl \
    dfu-util \
    flex \
    git \
    gperf \
    libffi-dev \
    libssl-dev \
    libusb-1.0-0 \
    ninja-build \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    xz-utils && \
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

ARG IDF_REF
ARG IDF_CLONE_URL=https://github.com/espressif/esp-idf.git
ARG IDF_CLONE_PATH=${IDF_TOOLS_PATH}/esp-idf

RUN git init "${IDF_CLONE_PATH}" && \
    cd "${IDF_CLONE_PATH}" && \
    git remote add origin "${IDF_CLONE_URL}" && \
    git fetch --depth 1 origin "${IDF_REF}" && \
    git checkout FETCH_HEAD && \
    git submodule update --init --recursive --depth 1 --jobs $(nproc) && \
    rm -rf "${IDF_CLONE_PATH}/.git" \
    "${IDF_CLONE_PATH}/docs" \
    "${IDF_CLONE_PATH}/examples"

ENV IDF_CCACHE_ENABLE=1

# IDF's own cmake too, as in the official image: export.sh then puts it on PATH
# before $IDF_PATH/tools, whose cmake/ directory GNU make 4.3 would otherwise
# pick up as the cmake command ("cmake: Permission denied").
RUN cd "${IDF_CLONE_PATH}" && \
    ./install.sh all && \
    python3 tools/idf_tools.py install cmake && \
    rm -rf "${IDF_TOOLS_PATH}/dist" /tmp/* /root/.cache

ENV ESP_IDF_INSTALLATION_PATH=${IDF_CLONE_PATH}

# Espressif LLVM (clang-tidy, clang-format) for the lint checks. ESP-IDF
# installs it only on request. It is esp-clang from the IDF v6.1.1
# tools/tools.json, the same one a local IDF v6.1.1 installs. Only clang (for
# its builtin headers), clang-tidy and clang-format are kept: the target
# runtimes in lib/clang-runtimes alone take 1.9 GB.
ARG ESP_CLANG_VERSION=esp-21.1.3_20260408
ARG ESP_CLANG_SHA256_AMD64=6e62bf1973b57b5388aad281ce1463e953e70b3d8df74ef4668c70f31fbeda63
ARG ESP_CLANG_SHA256_ARM64=a25e5446ba3aa4bccfafa4328cec240c5b1ae7638978d868c26777c4ceca241b
ARG TARGETARCH
ENV ESP_CLANG_PATH=/opt/esp-clang

RUN set -euo pipefail && \
    case "${TARGETARCH:-amd64}" in \
      amd64) ARCH=x86_64; SHA256="${ESP_CLANG_SHA256_AMD64}" ;; \
      arm64) ARCH=aarch64; SHA256="${ESP_CLANG_SHA256_ARM64}" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac && \
    curl -fsSL -o /tmp/esp-clang.tar.xz \
      "https://github.com/espressif/llvm-project/releases/download/${ESP_CLANG_VERSION}/clang-${ESP_CLANG_VERSION}-${ARCH}-linux-gnu.tar.xz" && \
    echo "${SHA256}  /tmp/esp-clang.tar.xz" | sha256sum -c - && \
    mkdir -p "${ESP_CLANG_PATH}" && \
    tar -xJf /tmp/esp-clang.tar.xz -C "${ESP_CLANG_PATH}" --strip-components=1 && \
    rm -f /tmp/esp-clang.tar.xz && \
    cd "${ESP_CLANG_PATH}" && \
    find bin -mindepth 1 \
      ! -name clang ! -name clang++ ! -name 'clang-[0-9]*' \
      ! -name clang-tidy ! -name clang-format ! -name run-clang-tidy \
      -exec rm -rf {} + && \
    find lib -mindepth 1 -maxdepth 1 ! -name clang -exec rm -rf {} + && \
    rm -rf docs samples share && \
    bin/clang --version && \
    bin/clang-tidy --version && \
    bin/clang-format --version && \
    du -sh "${ESP_CLANG_PATH}"

ENV PATH=${ESP_CLANG_PATH}/bin:${PATH}

COPY --chmod=755 entrypoint.sh ${IDF_TOOLS_PATH}/entrypoint.sh
ENTRYPOINT ["/opt/esp/entrypoint.sh"]
