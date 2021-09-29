# QemuRpiRunner
Running ARM8 Rpi instance in qemu

# 1.build.sh - run only once
Creates a docker image from Ubuntu
- download raspios buster arm64
- download kernel source
- compile kernel
- adapt fstab, cmdline, ssh
- convert to qcow2
- export kernel, pi3.dtb and distro.qcow2

# 2.export.sh - run only once
Run the container and export kernel, pi3.dtb and distro.qcow2 files to dist folder

# 3.build-qemu.sh - run only once
Download and compile locally newest qemu with aarch64 support

# 4.run.sh
Run locally compiled qemu with necessary files to run Rpi in command line

# Usage
After run you can ssh with ```ssh pi@localhost -p 2222```

When you go home, use ```sudo shutdown now``` to close Rpi with safe
