#!/usr/bin/env bash
set -x

ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

tar -xvzf /home/packer/artifacts.tar.gz -C /

mkdir -p /opt/cni/bin
mkdir -p /etc/cni/net.d
mkdir -p /etc/kubernetes/certs
mkdir -p /etc/containerd
mkdir -p /etc/systemd/system/kubelet.service.d
mkdir -p /var/lib/kubelet

curl -LO https://dl.k8s.io/v1.25.4/kubernetes-node-linux-amd64.tar.gz
tar -xvzf kubernetes-node-linux-amd64.tar.gz kubernetes/node/bin/{kubelet,kubectl}
mv kubernetes/node/bin/{kubelet,kubectl} /usr/local/bin
# rm kubernetes-node-linux-amd64.tar.gz

# azure cni (only)
curl -LO https://github.com/Azure/azure-container-networking/releases/download/v1.4.12/azure-vnet-cni-linux-amd64-v1.4.12.tgz
tar -xvzf azure-vnet-cni-linux-amd64-v1.4.12.tgz -C /opt/cni/bin
mv /opt/cni/bin/10-azure.conflist /etc/cni/net.d/10-azure.conflist

# cni plugins
curl -LO https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz
tar -xvzf cni-plugins-linux-amd64-v1.0.1.tgz -C /opt/cni/bin/
# rm cni-plugins-linux-amd64-v1.0.1.tgz

# runc
curl -o runc -L https://github.com/opencontainers/runc/releases/download/v1.0.2/runc.amd64
install -m 0555 runc /usr/local/sbin/runc
# rm runc

# containerd
curl -LO https://github.com/containerd/containerd/releases/download/v1.6.4/containerd-1.6.4-linux-amd64.tar.gz
tar -xvzf containerd-1.6.4-linux-amd64.tar.gz -C /usr
# rm containerd-1.6.4-linux-amd64.tar.gz

tee /etc/systemd/system/containerd.service > /dev/null <<EOF
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target
[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/bin/containerd
Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=infinity
# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999
[Install]
WantedBy=multi-user.target
EOF

containerd config default > /etc/containerd/config.toml
systemctl enable --now containerd

which waagent
