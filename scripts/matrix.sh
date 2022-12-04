#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

nix develop -c cue export $REPO_ROOT/matrix.cue > matrix.json
nix develop -c -- bash -c "cat matrix.json| jq -c -r '[(.versions|keys),(.skus|keys)] | combinations | { ( ( \"packer-\" + .[0] + \"-\" + .[1] ) | split(\".\") | join(\"-\") ): {\"kube_version\": .[0], \"sku\": .[1]}}' | jq -n 'reduce inputs as \$in (null; . + \$in)'" | sponge matrix.json
