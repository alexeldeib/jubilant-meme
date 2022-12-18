#!/usr/bin/env bash
set -euxo pipefail

REPO_ROOT=$(realpath $(dirname "${BASH_SOURCE[0]}")/..)

source /etc/os-release

src=$(pwd)
root=$(pwd)/$(mktemp -d final-XXXX)
work=$(pwd)/$(mktemp -d work-XXXX)
pushd $work || exit 1
mkdir -p $root/usr/local/bin
mkdir -p $root/opt/containerd
mkdir -p $root/opt/runc
mkdir -p $root/opt/cni/bin
mkdir -p $root/etc/cni/net.d
mkdir -p $root/etc/kubernetes/certs
mkdir -p $root/etc/containerd
mkdir -p $root/etc/systemd/system/kubelet.service.d
mkdir -p $root/var/lib/kubelet
mkdir -p $root/opt/azure/k8s

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

for kube_version in $(jq -r -c 'keys[]' versions.json); do
    mkdir -p $root/opt/azure/k8s/$kube_version
    wget "https://acs-mirror.azureedge.net/kubernetes/v${kube_version}/binaries/kubernetes-node-linux-amd64.tar.gz" &> /dev/null 
    tar -xvzf kubernetes-node-linux-amd64.tar.gz --strip-components=3 -C $root/opt/azure/k8s/$kube_version kubernetes/node/bin/kubelet kubernetes/node/bin/kubectl > /dev/null 2>&1
done

sudo apt-get download moby-containerd moby-runc
mv moby-runc* $root/opt/runc/
mv moby-containerd* $root/opt/containerd/

# azure cni (only)
wget https://github.com/Azure/azure-container-networking/releases/download/v1.4.12/azure-vnet-cni-linux-amd64-v1.4.12.tgz  &> /dev/null
tar -xvzf azure-vnet-cni-linux-amd64-v1.4.12.tgz -C $root/opt/cni/bin
mv $root/opt/cni/bin/10-azure.conflist $root/etc/cni/net.d/10-azure.conflist

# cni plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz  &> /dev/null
tar -xvzf cni-plugins-linux-amd64-v1.0.1.tgz -C $root/opt/cni/bin/
rm cni-plugins-linux-amd64-v1.0.1.tgz

cp $REPO_ROOT/artifacts/kubelet-ready.service $root/etc/systemd/system/kubelet-ready.service
chmod a=r,o=w $root/etc/systemd/system/kubelet-ready.service
cp $REPO_ROOT/artifacts/join.sh $root/opt/azure/join.sh
chmod a=rx $root/opt/azure/join.sh
cp $REPO_ROOT/artifacts/imds-ready.service $root/etc/systemd/system/imds-ready.service
chmod a=r,o=w $root/etc/systemd/system/imds-ready.service
cp $REPO_ROOT/artifacts/imds-ready.sh $root/opt/azure/imds-ready.sh
chmod a=rx $root/opt/azure/join.sh

# KEY: this packages everything into a tar archive with relative directories to the root fs (/)
# this allows us to directly untar the entire package at once, with all files in the correct locations
tar -cvzf artifacts.tar.gz -C $root .
tar -tzf artifacts.tar.gz

echo "pwd: $(pwd)"
ls -al
cp artifacts.tar.gz ../artifacts.tar.gz
cp artifacts.tar.gz $src/artifacts.tar.gz

popd
