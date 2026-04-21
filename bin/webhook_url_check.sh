#!/usr/bin/env bash
set -euo pipefail

TRUSTED_BASE="${1:?trusted base URL required}"
URL="${2:?webhook URL required}"

# Strip a single trailing slash from the base so the prefix check below can
# always append "/". Requiring the URL to start with "<base>/" prevents a host
# like "packagist.com.evil.example" from sneaking past "packagist.com".
TRUSTED_BASE="${TRUSTED_BASE%/}"

case "${TRUSTED_BASE}" in
    https://*) ;;
    *) echo "::error ::packagist_url must use https://, got '${TRUSTED_BASE}'"; exit 1 ;;
esac

case "${URL}" in
    "${TRUSTED_BASE}/"*) ;;
    *) echo "::error ::webhook URL '${URL}' is not under the trusted base '${TRUSTED_BASE}/'"; exit 1 ;;
esac

# Restrict the path portion after the trusted base to alphanumerics, dashes,
# and forward slashes. This blocks query strings, fragments, percent-encoding,
# and any other characters that have no business appearing in a Conductor
# webhook callback path.
SUFFIX="${URL#"${TRUSTED_BASE}/"}"
case "${SUFFIX}" in
    *[!A-Za-z0-9/-]*)
        echo "::error ::webhook URL path '${SUFFIX}' must contain only alphanumerics, '-' and '/'"
        exit 1
        ;;
esac
