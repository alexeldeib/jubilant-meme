#!/usr/bin/env bash
set -uo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -yq
apt-get \
  -o Dpkg::Options::="--force-confnew" \
  -o Dpkg::Options::="--force-confdef" \
  -yq install \
  apt-transport-https \
  ca-certificates \
  ceph-common \
  cgroup-lite \
  cifs-utils \
  conntrack \
  cracklib-runtime \
  ebtables \
  ethtool \
  git \
  glusterfs-client \
  htop \
  iftop \
  init-system-helpers \
  inotify-tools \
  iotop \
  iproute2 \
  ipset \
  iptables \
  nftables \
  jq \
  libpam-pwquality \
  libpwquality-tools \
  mount \
  nfs-common \
  pigz \
  socat \
  sysfsutils \
  sysstat \
  traceroute \
  util-linux \
  xz-utils \
  netcat \
  dnsutils \
  zip \
  rng-tools \
  kmod \
  gcc \
  make \
  dkms \
  initramfs-tools \
  linux-headers-$(uname -r) || exit 1

bash /opt/azure/cis.sh || exit 1

systemctl enable disk-queue.service
systemctl restart disk-queue.service
# systemctl enable kubelet-ready.service
# systemctl enable imds-ready.service
# systemctl status kubelet-ready.service
# systemctl status imds-ready.service
# systemctl restart imds-ready.service
# sleep 5
# systemctl status imds-ready.service
# sleep 2
# journalctl -u imds-ready --no-tail
systemd-analyze critical-chain
systemd-analyze critical-chain imds-ready.service
