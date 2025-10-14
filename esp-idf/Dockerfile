ARG IDF_TAG=latest
FROM espressif/idf:${IDF_TAG}

ARG LLVM_VERSION=17

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    clang-${LLVM_VERSION} \
    clang-tidy-${LLVM_VERSION} \
    clang-format-${LLVM_VERSION} \
    jq && \
    update-alternatives \
    --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100 \
    --slave   /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} \
    --slave   /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} \
    --slave   /usr/bin/clang-format clang-format /usr/bin/clang-format-${LLVM_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
