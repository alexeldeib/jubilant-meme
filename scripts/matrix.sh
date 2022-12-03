#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

cue export "$REPO_ROOT/matrix.cue" | jq -c -r '[(.versions|keys),(.skus|keys)] | combinations | { ( .[0] + "-" + .[1] ): {"name": .[0], "val": .[1]}}'
