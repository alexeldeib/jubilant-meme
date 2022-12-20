#!/usr/bin/env bash
set -uo pipefail

source /etc/os-release

if [[ "${NAME}" == "Ubuntu" ]]; then
    aptarch="prod"
    if [[ "${VERSION_ID}" == "18.04" ]]; then
        aptarch="multiarch/prod"
    fi

    echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/${VERSION_ID}/${aptarch} ${VERSION_CODENAME} main" > microsoft-prod.list
    echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/${VERSION_ID}/${aptarch} testing main" > microsoft-prod-testing.list
    sudo mv microsoft-prod.list /etc/apt/sources.list.d/microsoft-prod.list
    sudo mv microsoft-prod-testing.list /etc/apt/sources.list.d/microsoft-prod-testing.list

    wget https://packages.microsoft.com/keys/microsoft.asc
    gpg --dearmor < microsoft.asc > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo apt update -yq
fi

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
