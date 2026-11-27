#!/usr/bin/env bash
set -e

. "$IDF_TOOLS_PATH/esp-idf/export.sh"
. "$ESP_MATTER_PATH/export.sh"

exec "$@"
