# dockerfiles

Docker images for Espressif embedded development, published to `ghcr.io/sivakov512`.

## Images

### `llvm`

Ubuntu 24.04 with the LLVM toolchain configured via `update-alternatives`.

**Includes:** `clang`, `clang++`, `clang-tidy`, `clang-format`, `lld`

| Tags | LLVM |
|------|------|
| `19`, `latest` | 19 |

```sh
docker pull ghcr.io/sivakov512/llvm:latest
```

---

### `esp-idf`

Built on top of `llvm`. Contains [ESP-IDF](https://github.com/espressif/esp-idf) with all toolchains pre-installed. `docs` and `examples` are stripped to reduce image size. The entrypoint sources `export.sh` automatically.

| Tags | ESP-IDF | LLVM |
|------|---------|------|
| `v5.5.3-llvm19`, `v5.5.3`, `latest` | v5.5.3 | 19 |
| `v5.4.3-llvm19`, `v5.4.3` | v5.4.3 | 19 |

```sh
docker pull ghcr.io/sivakov512/esp-idf:latest
```

---

### `esp-matter`

Built on top of `esp-idf`. Contains the [ESP Matter](https://github.com/espressif/esp-matter) SDK. `docs` and `examples` are stripped to reduce image size. The entrypoint sources both `esp-idf/export.sh` and `esp-matter/export.sh`.

| Tags | ESP Matter | ESP-IDF | LLVM |
|------|------------|---------|------|
| `main-idf_v5.5.3-llvm19`, `main-idf_v5.5.3`, `latest` | main | v5.5.3 | 19 |
| `main-idf_v5.4.3-llvm19`, `main-idf_v5.4.3` | main | v5.4.3 | 19 |
| `release_v1.5-idf_v5.5.3-llvm19`, `release_v1.5-idf_v5.5.3` | release/v1.5 | v5.5.3 | 19 |
| `release_v1.5-idf_v5.4.3-llvm19`, `release_v1.5-idf_v5.4.3` | release/v1.5 | v5.4.3 | 19 |

```sh
docker pull ghcr.io/sivakov512/esp-matter:latest
```

## Usage

```sh
docker run --rm -v $(pwd):/project -w /project \
  ghcr.io/sivakov512/esp-idf:latest \
  idf.py build
```

Replace the image with `esp-matter` for Matter projects.

## CI/CD

Images are built and pushed via GitHub Actions:

- **On push** to `main` when files in the relevant image directory change.
- **On a weekly schedule** (every Sunday at 03:00 UTC) — `esp-idf` only.
- **Manually** via `workflow_dispatch`.

The `esp-matter` workflow triggers automatically after `esp-idf` completes successfully.