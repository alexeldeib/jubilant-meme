#!/usr/bin/env bash
set -euo pipefail
export CGO_ENABLED=0

go install cuelang.org/go/cmd/cue@v0.4.2
go install github.com/evanphx/json-patch/cmd/json-patch@latest
go install github.com/open-policy-agent/conftest@latest
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x ./jq-linux64
mv jq-linux64 "$(go env GOPATH)/bin/jq"

sudo apt-get update -yq
sudo apt-get install -yq --no-install-recommends moreutils

