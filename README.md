# dockerfiles

Docker images for Espressif embedded development, published to `ghcr.io/sivakov512`.

Each image carries [Espressif LLVM](https://github.com/espressif/llvm-project) (`esp-clang`) for `clang-tidy` and `clang-format`, trimmed to `clang`, `clang-tidy` and `clang-format`. ESP-IDF installs `esp-clang` only on request. The version is the one ESP-IDF v6.1.1 lists in `tools/tools.json`, so CI checks run with the same tools as a local IDF v6.1.1 install.

## Images

### `esp-idf`

Ubuntu 24.04 with [ESP-IDF](https://github.com/espressif/esp-idf) and all its toolchains. IDF is a shallow clone without `.git`, `docs` and `examples`, which keeps the image small enough for private-repo GitHub runners (the official `espressif/idf` image is about 4 GB compressed). The entrypoint sources `export.sh` automatically. Built for `linux/amd64` and `linux/arm64`, so it also runs natively on Apple Silicon.

| Tags | ESP-IDF | esp-clang |
|------|---------|-----------|
| `v6.1.1`, `latest` | v6.1.1 | 21.1.3 |
| `v6.0.2` | v6.0.2 | 21.1.3 |

```sh
docker pull ghcr.io/sivakov512/esp-idf:latest
```

---

### `esp-matter`

Built on top of the official [`espressif/esp-matter`](https://hub.docker.com/r/espressif/esp-matter) image. The entrypoint sources both `esp-idf/export.sh` and `esp-matter/export.sh` and keeps the working directory, so it can also be sourced from CI steps.

| Tags | ESP Matter | ESP-IDF | esp-clang |
|------|------------|---------|-----------|
| `release_v1.6.1-idf_v6.0.2`, `latest` | release/v1.6.1 | v6.0.2 | 21.1.3 |

ESP-IDF v6.0.2 is the version esp-matter recommends for release/v1.6.1.

```sh
docker pull ghcr.io/sivakov512/esp-matter:latest
```

---

### Old tags

Older tags stay published but are no longer rebuilt: `llvm:19` and `llvm:latest`, `esp-idf:*-llvm19` and `esp-idf:v5.*`, `esp-matter:*-idf_v5.*`.

## Usage

```sh
docker run --rm -v $(pwd):/project -w /project \
  ghcr.io/sivakov512/esp-idf:latest \
  idf.py build
```

Replace the image with `esp-matter` for Matter projects.

## CI/CD

Images are built via GitHub Actions:

- **On pull requests** that change an image: built, not pushed.
- **On push** to `main` when files in the relevant image directory change: built and pushed.
- **On a weekly schedule** (Sundays, 03:00 UTC for `esp-idf`, 04:00 UTC for `esp-matter`), to pick up updates of the base images.
- **Manually** via `workflow_dispatch`.
