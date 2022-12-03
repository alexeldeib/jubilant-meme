#!/usr/bin/env bash
set -o errexit

sudo apt-get update
sudo apt-get install -yq -o DPkg::Options::=--force-confnew curl gnupg2 xz-utils sudo procps tree
sudo mkdir -m 0777 /nix
sudo chown root /nix
curl -o install-nix-2.11.1 https://releases.nixos.org/nix/nix-2.11.1/install
curl -o install-nix-2.11.1.asc https://releases.nixos.org/nix/nix-2.11.1/install.asc
gpg2 --keyserver hkps://keyserver.ubuntu.com --recv-keys B541D55301270E0BCF15CA5D8170B4726D7198DE
gpg2 --verify ./install-nix-2.11.1.asc

sudo groupadd nonroot -g 65532
sudo useradd nonroot -u 65532 -g 65532
sudo mkdir -p /home/nonroot
sudo chown nonroot /home/nonroot

sudo mkdir -p /etc/sudoers.d
sudo tee /etc/sudoers.d/$(whoami) > /dev/null <<EOF
$(whoami) ALL=(ALL) NOPASSWD:ALL
EOF

sudo tee /etc/sudoers.d/nonroot > /dev/null <<EOF
nonroot ALL=(ALL) NOPASSWD:ALL
EOF

sudo mkdir -p /etc/nix
sudo mkdir -p $HOME/.config/nix

sudo tee /etc/nix/nix.conf > /dev/null <<EOF
build-users-group = nixbld
trusted-users = root cloudtest
EOF
sudo chmod a+r /etc/nix/nix.conf

sudo tee $HOME/.config/nix/nix.conf > /dev/null <<EOF
experimental-features = nix-command flakes
EOF

sudo su nonroot -c 'sh ./install-nix-2.11.1 --daemon'
set -x
sudo su nonroot -c '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && which nix-daemon'
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
echo "which nix-daemon"
which nix-daemon
nix-shell -p nix-info --run "nix-info -m"
sudo systemctl list-units | grep nix
sudo pkill nix-daemon
sudo systemctl list-units | grep nix
