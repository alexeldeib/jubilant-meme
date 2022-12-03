#!/usr/bin/env bash
set -euo pipefail

jq '[(.versions|keys),(.skus|keys)] | combinations | join("-")' matrix.json
