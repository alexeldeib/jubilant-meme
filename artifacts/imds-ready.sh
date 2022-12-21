#!/usr/bin/env bash
systemd-notify --status="Starting imds-ready check"
res=$(curl -o /dev/null -w "%{http_code}" -fsSL -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01")
start="$(date -Isec)"
echo "started at $start"
until test "$res" == "200"; do
   echo "the curl command failed with: $res"
   res=$(curl -o /dev/null -w "%{http_code}" -fsSL -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01")
   sleep 1
done
echo "started at $start"
# curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq
msg="imds reachable at $(date -Isec)"
systemd-notify --ready --status="$msg"
