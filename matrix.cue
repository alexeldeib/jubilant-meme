{
    "skus": {
        // "ubuntu-18-04-gen1": {
        //     "patches": [
        //         "packer/market-src-patch.json",
        //         "packer/sig-dest-patch.json",
        //     ],
        //     "variables": {
        //         "image_offer": "UbuntuServer",
        //         "image_publisher": "Canonical",
        //         "image_sku": "18.04-LTS",
        //         "image_version": "latest",
        //         "dest_subscription_id": "{{env `SUBSCRIPTION`}}",
        //         "dest_resource_group_name": "{{ env `GROUP`}}",
        //         "dest_gallery_name": "{{ env `GALLERY`}}",
        //         "dest_image_name": "ubuntu1804gen1",
        //         "dest_image_version": "0.0.1"
        //     }
        // },
        // "ubuntu-18-04-gen1-fips": {
        // "generation": "V1",
        //      "variables": {
        //         "image_offer": "UbuntuServer",
        //         "image_publisher": "Canonical",
        //         "image_sku": "18.04-LTS",
        //         "image_version": "latest"
        //     }
        // },
        // "ubuntu-18-04-gen1-gpu": {
            // "generation": "V1",
        //      "variables": {
        //         "image_offer": "UbuntuServer",
        //         "image_publisher": "Canonical",
        //         "image_sku": "18.04-LTS",
        //         "image_version": "latest"
        //     }
        // },
        // "ubuntu-18-04-gen1-fips-gpu": {
            // "generation": "V2",
        //      "variables": {
        //         "image_offer": "UbuntuServer",
        //         "image_publisher": "Canonical",
        //         "image_sku": "18.04-LTS",
        //         "image_version": "latest"
        //     }
        // },
        "ubuntu-18-04-gen2": {
            "generation": "V2",
            "patches": [
                "packer/market-src-patch.json",
                "packer/sig-dest-patch.json",
            ],
             "variables": {
                "image_offer": "UbuntuServer",
                "image_publisher": "Canonical",
                "image_sku": "18_04-LTS-GEN2",
                "image_version": "latest",
                "dest_subscription_id": "{{env `SUBSCRIPTION`}}",
                "dest_resource_group_name": "{{ env `GROUP`}}",
                "dest_gallery_name": "{{ env `GALLERY`}}",
                "dest_image_name": "ubuntu1804gen2",
                "dest_image_version": "0.0.1"
            }
        },
        // "ubuntu-18-04-gen2-fips": {
        // "generation": "V2",
        //      "variables": {
        //         "image_offer": "UbuntuServer",
        //         "image_publisher": "Canonical",
        //         "image_sku": "18_04-LTS-GEN2",
        //         "image_version": "latest"
        //     }
        // },
        // "ubuntu-18-04-gen2-gpu": {
            // "generation": "V2",
        //      "variables": {
        //         "image_offer": "UbuntuServer",
        //         "image_publisher": "Canonical",
        //         "image_sku": "18_04-LTS-GEN2",
        //         "image_version": "latest"
        //     }
        // },
        // "ubuntu-18-04-gen2-fips-gpu": {
            // "generation": "V2",
        //      "variables": {
        //         "image_offer": "UbuntuServer",
        //         "image_publisher": "Canonical",
        //         "image_sku": "18_04-LTS-GEN2",
        //         "image_version": "latest"
        //     }
        // },
        // "ubuntu-20-04-gen2-cvm": {
            // "generation": "V2",
        //     "variables": {
        //         "image_offer": "0001-com-ubuntu-confidential-vm-focal",
        //         "image_publisher": "Canonical",
        //         "image_sku": "20_04-lts-cvm",
        //         "image_version": "20.04.202205260"
        //     }
        // },
        // "ubuntu-22-04-gen1": {
            // "generation": "V1",
        //     "patches": [
        //         "packer/market-src-patch.json",
        //         "packer/sig-dest-patch.json",
        //     ],
        //     "variables": {
        //         "image_offer": "0001-com-ubuntu-server-jammy",
        //         "image_publisher": "Canonical",
        //         "image_sku": "22_04-lts",
        //         "image_version": "latest"
        //         "dest_subscription_id": "{{env `SUBSCRIPTION`}}",
        //         "dest_resource_group_name": "{{ env `GROUP`}}",
        //         "dest_gallery_name": "{{ env `GALLERY`}}",
        //         "dest_image_name": "ubuntu2204gen1",
        //         "dest_image_version": "0.0.1"
        //     }
        // },
        "ubuntu-22-04-gen2": {
            "generation": "V2",
            "patches": [
                "packer/market-src-patch.json",
                "packer/sig-dest-patch.json",
            ],
            "variables": {
                "image_offer": "0001-com-ubuntu-server-jammy",
                "image_publisher": "Canonical",
                "image_sku": "22_04-lts-gen2",
                "image_version": "latest",
                "dest_subscription_id": "{{env `SUBSCRIPTION`}}",
                "dest_resource_group_name": "{{ env `GROUP`}}",
                "dest_gallery_name": "{{ env `GALLERY`}}",
                "dest_image_name": "ubuntu2204gen2",
                "dest_image_version": "0.0.1"
            }
        },
        // "ubuntu-22-04-gen2-arm64": { "generation": "V2" },
        "mariner-1-gen1": {
            "generation": "V1",
            "patches": [
                "packer/market-src-patch.json",
                "packer/sig-dest-patch.json",
            ],
            "variables": {
                "image_offer": "cbl-mariner",
                "image_publisher": "MicrosoftCBLMariner",
                "image_sku": "cbl-mariner-1",
                "image_version": "latest",
                "dest_subscription_id": "{{env `SUBSCRIPTION`}}",
                "dest_resource_group_name": "{{ env `GROUP`}}",
                "dest_gallery_name": "{{ env `GALLERY`}}",
                "dest_image_name": "mariner1gen1",
                "dest_image_version": "0.0.1"
            }
        },
        // "mariner-2-gen2": {
        //     "generation": "V2",
        //     "patches": [
        //         "packer/market-src-patch.json",
        //         "packer/sig-dest-patch.json",
        //     ],
        //     "variables": {
        //         "image_offer": "cbl-mariner",
        //         "image_publisher": "MicrosoftCBLMariner",
        //         "image_sku": "cbl-mariner-2-gen2",
        //         "image_version": "latest",
        //         "dest_subscription_id": "{{env `SUBSCRIPTION`}}",
        //         "dest_resource_group_name": "{{ env `GROUP`}}",
        //         "dest_gallery_name": "{{ env `GALLERY`}}",
        //         "dest_image_name": "mariner2gen2",
        //         "dest_image_version": "0.0.1"
        //     }
        // },
        // "mariner-2-gen2-kata": {
            // "generation": "V2",
        //     "variables": {
        //         "image_offer": "cbl-mariner",
        //         "image_publisher": "MicrosoftCBLMariner",
        //         "image_sku": "cbl-mariner-2-gen2",
        //         "image_version": "latest"
        //     }
        // },
        // "mariner-2-gen2-tl": {
            // "generation": "V2",
        // },
        // "mariner-2-gen2-kata-tl": {
            // "generation": "V2",
        // }
    },
    "versions": {
        "1.22.11": {},
        // "1.22.15": {},
        // "1.23.8": {},
        // "1.23.12": {},
        // "1.24.3": {},
        // "1.24.6": {},
        // "1.25.2": {},
        "1.25.4": {}
    }
}