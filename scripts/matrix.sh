#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/.

nix develop -c -- bash -c "cue export $REPO_ROOT/matrix.cue | jq -c -r '[(.versions|keys),(.skus|to_entries)] | combinations | { ( ( \"packer-\" + .[0] + \"-\" + .[1].key ) | split(\".\") | join(\"-\") ): {\"kube_version\": .[0], \"sku\": .[1].key, \"config\": .[1].value }}' | jq -n 'reduce inputs as \$in (null; . + \$in)'"
