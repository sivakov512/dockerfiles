#!/usr/bin/env bash
set -e

. $IDF_TOOLS_PATH/esp-idf/export.sh
. $IDF_TOOLS_PATH/esp-matter/export.sh

exec "$@"
