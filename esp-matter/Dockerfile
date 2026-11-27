# Official ESP-Matter image plus Espressif LLVM for clang-tidy and clang-format.
ARG BASE_TAG
FROM espressif/esp-matter:${BASE_TAG}
SHELL ["/bin/bash", "-c"]

# Espressif LLVM (clang-tidy, clang-format) for the lint checks. ESP-IDF
# installs it only on request, so the official image does not have it. Keep the
# version equal in esp-idf/ and esp-matter/: it is esp-clang from the IDF v6.1.1
# tools/tools.json, the same one a local IDF v6.1.1 installs.
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
    if ! command -v xz >/dev/null; then \
      apt-get update && \
      apt-get install -y --no-install-recommends xz-utils && \
      rm -rf /var/lib/apt/lists/*; \
    fi && \
    curl -fsSL -o /tmp/esp-clang.tar.xz \
      "https://github.com/espressif/llvm-project/releases/download/${ESP_CLANG_VERSION}/clang-${ESP_CLANG_VERSION}-${ARCH}-linux-gnu.tar.xz" && \
    echo "${SHA256}  /tmp/esp-clang.tar.xz" | sha256sum -c - && \
    mkdir -p "${ESP_CLANG_PATH}" && \
    tar -xJf /tmp/esp-clang.tar.xz -C "${ESP_CLANG_PATH}" --strip-components=1 && \
    rm -f /tmp/esp-clang.tar.xz && \
    "${ESP_CLANG_PATH}/bin/clang-tidy" --version && \
    "${ESP_CLANG_PATH}/bin/clang-format" --version

ENV PATH=${ESP_CLANG_PATH}/bin:${PATH}

# The official entrypoint cd's into $IDF_PATH and $ESP_MATTER_PATH. This one
# keeps the working directory, so CI can also source it (e.g. through BASH_ENV).
COPY --chmod=755 entrypoint.sh /opt/esp/entrypoint.sh
ENTRYPOINT ["/opt/esp/entrypoint.sh"]
CMD ["/bin/bash"]
