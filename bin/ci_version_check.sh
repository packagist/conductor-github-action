#!/usr/bin/env bash
set -euo pipefail

CURRENT_VERSION=${2}
MINIMUM_REQUIRED_VERSION=${1}

if [ $(printf '%s\n' "${MINIMUM_REQUIRED_VERSION}" "${CURRENT_VERSION}" | sort -V | head -1) != "${MINIMUM_REQUIRED_VERSION}" ]
then
  echo "::error Conductor GitHub Action version '${MINIMUM_REQUIRED_VERSION}' or higher is required"
  exit 1
fi
