FROM ubuntu:24.04

ARG LLVM_VERSION=19

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential cmake ca-certificates git \
    clang-${LLVM_VERSION} \
    clang-tidy-${LLVM_VERSION} \
    clang-format-${LLVM_VERSION} \
    lld-${LLVM_VERSION} && \
    update-ca-certificates && \
    update-alternatives \
    --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100 \
    --slave   /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} \
    --slave   /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} \
    --slave   /usr/bin/clang-format clang-format /usr/bin/clang-format-${LLVM_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
