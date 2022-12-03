#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

nix develop -c -- bash -c "cue export $REPO_ROOT/matrix.cue | jq -c -r '[(.versions|keys),(.skus|keys)] | combinations | { ( ( \"packer-\" + .[0] + \"-\" + .[1] ) | split(\".\") | join(\"-\") ): {\"kube_version\": .[0], \"sku\": .[1]}}' | jq -s add"
