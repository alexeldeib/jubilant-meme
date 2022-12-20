#!/usr/bin/env bash 

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

if [[ $(isARM64) == 1 ]]; then
  if [ "${VERSION_ID}" == "22.04" ]; then
    # 22.04 multiarch by default
    curl https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/prod.list > /tmp/microsoft-prod.list
  else
    # arm64, multiarch 18.04/20.04
    curl https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/multiarch/prod.list > /tmp/microsoft-prod.list
  fi
else
  # amd64, non multiarch 18.04/20.04
  curl https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/prod.list > /tmp/microsoft-prod.list
fi

cp /tmp/microsoft-prod.list /etc/apt/sources.list.d/
if [[ ${VERSION_ID} == "18.04" ]]; then 
  echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/${VERSION_ID}/multiarch/prod testing main" > /etc/apt/sources.list.d/microsoft-prod-testing.list
elif [[ ${VERSION_ID} == "20.04" || ${VERSION_ID} == "22.04" ]]; then
  echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/${VERSION_ID}/prod testing main" > /etc/apt/sources.list.d/microsoft-prod-testing.list
fi
    
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
cp /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
apt-get -yq update
