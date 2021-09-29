# Qemu Rpi Runner
Running ARM8 Rpi 3b+ instance in qemu

Follow these steps

# 1.build.sh - run only once
Creates a docker image from Ubuntu
- download raspios buster arm64
- download RPI kernel source (5.10.y)
- compile kernel
- adapt fstab, cmdline, ssh
- convert to qcow2
- export kernel, pi3.dtb and distro.qcow2 (Rpi 3b+)
- It can take up to 45 minutes

# 2.export.sh - run only once
Run the container and export kernel, pi3.dtb and distro.qcow2 files to dist folder

# 3.build-qemu.sh - run only once
It downloads and compiles newest qemu (with aarch64) locally

# 4.run.sh
You can run locally compiled qemu with necessary files to run Rpi 3b+ in command line

# Usage
The distro.qcow2 file defaults to approx. It is 1.5GB, but may increase in size during use. You can take up to 4GB. To back up, just save the distro.qcow2 file.

Attention! Running export.sh, if it existed before, overwrites the distro.qcow2 file. This will reset its contents so you get a newly installed system.

After run you can ssh to rpi with ```ssh pi@localhost -p 2222```. You can safely run ```apt update``` and ```apt dist-upgrade```.

When you go home, use ```sudo shutdown now``` to close Rpi with safe
