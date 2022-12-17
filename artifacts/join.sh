#!/usr/bin/env bash
set -uo pipefail

systemctl enable kubelet-ready.service
systemctl enable imds-ready.service
systemctl status kubelet-ready.service
systemctl status imds-ready.service
systemctl restart imds-ready.service
sleep 5
systemctl status imds-ready.service
