#!/usr/bin/env bash
curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq
res=$?
echo "started at $(date -Isec)"
until test "$res" != "0"; do
   echo "the curl command failed with: $res"
done
echo "imds reachable at $(date -Isec)"
