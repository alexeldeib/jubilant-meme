#!/usr/bin/env /bash

assignRootPW() {
  if grep '^root:[!*]:' /etc/shadow; then
    VERSION=$(grep DISTRIB_RELEASE /etc/*-release| cut -f 2 -d "=")
    SALT=$(openssl rand -base64 5)
    SECRET=$(openssl rand -base64 37)
    CMD="import crypt, getpass, pwd; print(crypt.crypt('$SECRET', '\$6\$$SALT\$'))"
    if [[ "${VERSION}" == "22.04" ]]; then
      HASH=$(python3 -c "$CMD")
    else
      HASH=$(python -c "$CMD")
    fi

    echo 'root:'$HASH | /usr/sbin/chpasswd -e || exit 1
  fi
}

assignFilePermissions() {
    FILES="
    auth.log
    alternatives.log
    cloud-init.log
    cloud-init-output.log
    daemon.log
    dpkg.log
    kern.log
    lastlog
    waagent.log
    syslog
    unattended-upgrades/unattended-upgrades.log
    unattended-upgrades/unattended-upgrades-dpkg.log
    azure-vnet-ipam.log
    azure-vnet-telemetry.log
    azure-cnimonitor.log
    azure-vnet.log
    kv-driver.log
    blobfuse-driver.log
    blobfuse-flexvol-installer.log
    landscape/sysinfo.log
    "
    for FILE in ${FILES}; do
        FILEPATH="/var/log/${FILE}"
        DIR=$(dirname "${FILEPATH}")
        mkdir -p ${DIR} || exit 1
        touch ${FILEPATH} || exit 1
        chmod 640 ${FILEPATH} || exit 1
    done
    find /var/log -type f -perm '/o+r' -exec chmod 'g-wx,o-rwx' {} \;
    chmod 600 /etc/passwd- || exit 1
    chmod 600 /etc/shadow- || exit 1
    chmod 600 /etc/group- || exit 1

    if [[ -f /etc/default/grub ]]; then
        chmod 644 /etc/default/grub || exit 1
    fi

    if [[ -f /etc/crontab ]]; then
        chmod 0600 /etc/crontab || exit 1
    fi
    for filepath in /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d; do
      chmod 0600 $filepath || exit 1
    done
}

setPWExpiration() {
  sed -i "s|PASS_MAX_DAYS||g" /etc/login.defs || exit 1
  grep 'PASS_MAX_DAYS' /etc/login.defs && exit 1
  sed -i "s|PASS_MIN_DAYS||g" /etc/login.defs || exit 1
  grep 'PASS_MIN_DAYS' /etc/login.defs && exit 1
  sed -i "s|INACTIVE=||g" /etc/default/useradd || exit 1
  grep 'INACTIVE=' /etc/default/useradd && exit 1
  echo 'PASS_MAX_DAYS 90' >> /etc/login.defs || exit 1
  grep 'PASS_MAX_DAYS 90' /etc/login.defs || exit 1
  echo 'PASS_MIN_DAYS 7' >> /etc/login.defs || exit 1
  grep 'PASS_MIN_DAYS 7' /etc/login.defs || exit 1
  echo 'INACTIVE=30' >> /etc/default/useradd || exit 1
  grep 'INACTIVE=30' /etc/default/useradd || exit 1
}

applyCIS() {
  setPWExpiration
  assignRootPW
  assignFilePermissions
}

applyCIS
