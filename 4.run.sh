#!/bin/bash

./qemu/build/qemu-system-aarch64 \
   -M raspi3b \
   -m 1G \
   -smp 4 \
   -kernel ./dist/kernel8.img \
   -dtb ./dist/pi3.dtb \
   -sd ./dist/distro.qcow2 \
   -no-reboot \
   -nographic \
   -device usb-net,netdev=net0 \
   -netdev user,id=net0,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 \
   -append "rw console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootdelay=1 loglevel=2 modules-load=dwc2,g_ether"
