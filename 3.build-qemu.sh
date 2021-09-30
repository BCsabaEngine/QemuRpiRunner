#!/bin/bash

mkdir -p ./qemu

git clone --depth 1  https://github.com/qemu/qemu ./qemu
patch ./qemu/hw/usb/dev-network.c ./src/qemu/hw/usb/dev-network.patch
cd ./qemu
./configure --target-list=aarch64-softmmu
make -j$(nproc)
