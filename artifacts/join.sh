#!/usr/bin/env bash
set -uo pipefail

source /etc/os-release
cat /etc/os-release

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
    sudo apt-get update -yq
fi

getCPUArch() {
    arch=$(uname -m)
    if [[ ${arch,,} == "aarch64" || ${arch,,} == "arm64"  ]]; then
        echo "arm64"
    else
        echo "amd64"
    fi
}

isARM64() {
    if [[ $(getCPUArch) == "arm64" ]]; then
        echo 1
    else
        echo 0
    fi
}

ubuntu_pkg_list=(apt-transport-https ca-certificates ceph-common cgroup-lite cifs-utils conntrack cracklib-runtime ebtables ethtool git glusterfs-client htop iftop init-system-helpers inotify-tools iotop iproute2 ipset iptables nftables jq libpam-pwquality libpwquality-tools mount nfs-common pigz socat sysfsutils sysstat traceroute util-linux xz-utils netcat dnsutils zip rng-tools kmod gcc make dkms initramfs-tools linux-headers-$(uname -r))
ubuntu_amd64_pkg_list=(blobfuse2)
ubuntu_18_20_amd64_pkg_list=(fuse blobfuse=1.4.5)
ubuntu_22_amd64_pkg_list=(fuse3)
mariner_pkg_list=(blobfuse ca-certificates check-restart cifs-utils cloud-init-azure-kvp conntrack-tools cracklib dnf-automatic ebtables ethtool fuse git inotify-tools iotop iproute ipset iptables jq kernel-devel logrotate lsof nmap-ncat nfs-utils pam pigz psmisc rsyslog socat sysstat traceroute util-linux xz zip)
mariner2_pkg_list=(apparmor-parser libapparmor blobfuse2)

if [[ "${ID}" == "ubuntu" ]]; then
  pkg_list=(${ubuntu_pkg_list[@]})
  if [[ $(isARM64) != 1 ]]; then
    pkg_list+=(${ubuntu_amd64_pkg_list})
    if [[ "${VERSION_ID}" == "18.04" || "${VERSION_ID}" == "20.04" ]]; then
      pkg_list+=(${ubuntu_18_20_amd64_pkg_list[@]})
    elif [[ "${VERSION_ID}" == "22.04" ]]; then
      pkg_list+=(${ubuntu_22_amd64_pkg_list[@]})
    fi
  fi
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -yq
  apt-get \
    -o Dpkg::Options::="--force-confnew" \
    -o Dpkg::Options::="--force-confdef" \
    -yq install "${pkg_list[@]}" || exit 1
elif [[ "${ID}" == "mariner" ]]; then
  pkg_list=(${mariner_pkg_list})
  if [[ "${VERSION_ID}" == "2.0" ]]; then
      pkg_list+=(${mariner2_pkg_list})
  fi
  dnf makecache -y
  dnf update -r --refresh
  dnf install -y "${pkg_list[@]}"
else
  echo "unknown os ${NAME}"
  exit 1
fi




bash /opt/azure/cis.sh || exit 1

systemctl enable disk-queue.service
systemctl restart disk-queue.service
systemctl enable kubelet-ready.service
systemctl enable imds-ready.service
systemctl status kubelet-ready.service
systemctl status imds-ready.service
systemctl restart imds-ready.service
sleep 5
systemctl status imds-ready.service
sleep 2
journalctl -u imds-ready --no-tail
systemd-analyze critical-chain
systemd-analyze critical-chain imds-ready.service
