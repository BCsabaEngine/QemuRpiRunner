#!/bin/bash

mkdir -p ./qemu

git clone https://github.com/qemu/qemu ./qemu
cd ./qemu
./configure --target-list=aarch64-softmmu
make -j4
