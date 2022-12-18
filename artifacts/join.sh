#!/usr/bin/env bash
set -uo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -yq
apt-get -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" -yq install jq

systemctl enable kubelet-ready.service
systemctl enable imds-ready.service
systemctl status kubelet-ready.service
systemctl status imds-ready.service
systemctl restart imds-ready.service
sleep 5
systemctl status imds-ready.service
journalctl -u imds-ready