#!/usr/bin/env bash
set -euo pipefail # fail on...failures
set -x # log commands as they run

root=$(dirname "${BASH_SOURCE[0]}")
RG_REGION=eastus
[[ -z "${RG_REGION}" ]] && echo "RG_REGION is not set" && exit 1

prefix="acedev"
timestamp="$(date -Isec | tr -d :+-)"

echo "Deploying scaffolding resources"
DOTNET_BUNDLE_EXTRACT_BASE_DIR=$(mktemp -d)
export DOTNET_BUNDLE_EXTRACT_BASE_DIR
az group create -l "${RG_REGION}" -n ${prefix}-packer
az deployment group create \
  -n deploy-scaffold-${timestamp} \
  -f ${root}/deploy.bicep \
  -g ${prefix}-packer \
  --parameters \
    location=${RG_REGION}
