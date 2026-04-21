#!/usr/bin/env bash
set -euo pipefail

EXPECTED_SUBCOMMAND="${1:?expected subcommand required}"
: "${COMPOSER_COMMAND_STRING:?COMPOSER_COMMAND_STRING not set}"

# `read -ra` splits on $IFS only; it does not expand $vars, run command
# substitutions, honour quoting, or perform globbing. Every shell metacharacter
# in the payload therefore stays as a literal byte inside its token.
read -ra TOKENS <<< "${COMPOSER_COMMAND_STRING}"

if [[ "${#TOKENS[@]}" -lt 2 ]]; then
    echo "::error ::composer command must contain at least a binary and a subcommand"
    exit 1
fi

if [[ "${TOKENS[0]}" != "composer" ]]; then
    echo "::error ::composer command must start with 'composer', got '${TOKENS[0]}'"
    exit 1
fi

if [[ "${TOKENS[1]}" != "${EXPECTED_SUBCOMMAND}" ]]; then
    echo "::error ::composer subcommand must be '${EXPECTED_SUBCOMMAND}', got '${TOKENS[1]}'"
    exit 1
fi

# Reject tokens containing characters that have no business
# appearing in a Composer package name, version constraint, or flag.
SAFE_TOKEN_RE='^[A-Za-z0-9._:/@^+|=~*,<>!-]+$'
for token in "${TOKENS[@]}"; do
    if [[ ! "${token}" =~ ${SAFE_TOKEN_RE} ]]; then
        echo "::error ::composer command token '${token}' contains disallowed characters"
        exit 1
    fi
done

set -x
# Argv-form execution: bash passes each array element as one argv entry with
# no further parsing, so metacharacters inside a token reach composer as
# literal string data rather than as shell syntax.
exec composer "${TOKENS[@]:1}"
