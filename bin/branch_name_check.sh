#!/usr/bin/env bash
set -euo pipefail

BRANCH="${1:?branch name required}"

# Require every Conductor-managed branch to start with one of the allowed
# prefixes ("conductor" or the legacy "private-packagist-updates") and contain
# only characters that are safe inside a git refspec.
BRANCH_RE='^(conductor|private-packagist-updates)[A-Za-z0-9._/-]*$'

if [[ ! "${BRANCH}" =~ ${BRANCH_RE} ]]; then
    echo "::error ::branch '${BRANCH}' is not allowed; must start with 'conductor' or 'private-packagist-updates' and contain only [A-Za-z0-9._/-]"
    exit 1
fi
