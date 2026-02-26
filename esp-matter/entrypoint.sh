#!/usr/bin/env bash
set -e

if [ -n "${IDF_GIT_SAFE_DIR+x}" ]
then
	echo "Adding following directories into git's safe.directory"
	echo "$IDF_GIT_SAFE_DIR" | tr ':' '\n' | while read -r dir
	do
		git config --global --add safe.directory "$dir"
		echo "  $dir"
	done
fi

. $IDF_PATH/export.sh
. $ESP_MATTER_CLONE_PATH/export.sh

exec "$@"
