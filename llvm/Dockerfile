FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

ARG LLVM_VERSION=19

RUN apt-get update && \
    # Install all required stuff
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ca-certificates \
    git \
    clang-${LLVM_VERSION} \
    clang-tidy-${LLVM_VERSION} \
    clang-format-${LLVM_VERSION} \
    lld-${LLVM_VERSION} \
    jq \
    curl && \
    # Update alternatives
    update-ca-certificates && \
    update-alternatives \
    --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100 \
    --slave   /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} \
    --slave   /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} \
    --slave   /usr/bin/clang-format clang-format /usr/bin/clang-format-${LLVM_VERSION} && \
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

CMD ["/bin/bash"]
