#!/usr/bin/env bash
set -euo pipefail

MINIMUM_REQUIRED_VERSION=${1}

COMPOSER_PATH="$(which composer)"

if ! command -V $COMPOSER_PATH 2>&1 >/dev/null
then
    echo "::error ::Composer not found at '${COMPOSER_PATH}'"
    exit 1
fi

COMPOSER_VERSION="$($COMPOSER_PATH -V 2>&1 | head -n 1|  awk '{print $3}')"

if [ $(printf '%s\n' "${MINIMUM_REQUIRED_VERSION}" "${COMPOSER_VERSION}" | sort -V | head -1) != "${MINIMUM_REQUIRED_VERSION}" ]
then
  echo "::error ::Composer version '${MINIMUM_REQUIRED_VERSION}' or higher is required"
  exit 1
fi
