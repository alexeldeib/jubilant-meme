#!/usr/bin/env bash
set -euxo pipefail

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

# produce an output vhd for the cartesian product
# of kubernetes versions * VHD skus
# cue export $REPO_ROOT/matrix.cue | jq -c -r '[(.versions|keys),(.skus|to_entries)] | combinations | { ( ( "packer-" + .[0] + "-" + .[1].key ) | split(".") | join("-") ): {"kube_version": .[0], "sku": .[1].key }}' | jq -n 'reduce inputs as $in (null; . + $in)'
cue export $REPO_ROOT/matrix.cue | jq -r '.skus | keys | map(. as $key | { ($key): { "sku": $key } }) | add'
