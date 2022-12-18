#!/usr/bin/env bash
curl -fsSL -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
echo "started at $(date -Isec)"
until test "$res" == "0"; do
   echo "the curl command failed with: $res"
   curl -fsSL -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
   res=$?
done
curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq
msg="imds reachable at $(date -Isec)"
# systemd-notify --ready --status="$msg"
