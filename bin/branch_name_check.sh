#!/usr/bin/env bash
set -euo pipefail

BRANCH="${1:?branch name required}"

# Require every Conductor-managed branch to start with the literal prefix
# "conductor" and contain only characters that are safe inside a git refspec.
BRANCH_RE='^conductor[A-Za-z0-9._/-]*$'

if [[ ! "${BRANCH}" =~ ${BRANCH_RE} ]]; then
    echo "::error ::branch '${BRANCH}' is not allowed; must start with 'conductor' and contain only [A-Za-z0-9._/-]"
    exit 1
fi
