FROM ubuntu:20.04 as builder

ARG BUILD_DIR=/build/

ARG KERNEL_GIT=https://github.com/raspberrypi/linux.git
ARG KERNEL_BRANCH=rpi-5.4.y

ARG DISTRO_FILE=2021-05-07-raspios-buster-arm64-lite
ARG DISTRO_IMG=https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2021-05-28/$DISTRO_FILE.zip

ARG KERNEL=kernel8
ARG ARCH=arm64
ARG CROSS_COMPILE=aarch64-linux-gnu-
ARG BUILD_CORES=3

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt install -y \
    bc \
    bison \
    crossbuild-essential-arm64 \
    flex \
    git \
    libc6-dev \
    libguestfs-tools \
    libssl-dev \
    linux-image-generic \
    make \
    unzip \
    wget

RUN wget -nv -O /tmp/$DISTRO_FILE.zip $DISTRO_IMG \
 && unzip /tmp/$DISTRO_FILE.zip -d /tmp

RUN mkdir /mnt/root /mnt/boot \
 && guestfish add tmp/$DISTRO_FILE.img : run : mount /dev/sda1 / : copy-out / /mnt/boot : umount / : mount /dev/sda2 / : copy-out / /mnt/root

RUN git clone --single-branch --branch $KERNEL_BRANCH $KERNEL_GIT $BUILD_DIR/linux/
COPY src/.config $BUILD_DIR/linux/

RUN make -C $BUILD_DIR/linux/ -j$BUILD_CORES Image modules dtbs

RUN cp $BUILD_DIR/linux/arch/arm64/boot/Image /mnt/boot/kernel8.img \
 && cp $BUILD_DIR/linux/arch/arm64/boot/dts/broadcom/*.dtb /mnt/boot/ \
 && cp $BUILD_DIR/linux/arch/arm64/boot/dts/overlays/*.dtb* /mnt/boot/overlays/ \
 && cp $BUILD_DIR/linux/arch/arm64/boot/dts/overlays/README /mnt/boot/overlays/ \
 && make -C $BUILD_DIR/linux/ INSTALL_MOD_PATH=/mnt/root modules_install

COPY src/fstab /mnt/root/etc/
COPY src/cmdline.txt /mnt/boot/
RUN touch /mnt/boot/ssh

RUN guestfish -N $BUILD_DIR/distro.img=bootroot:vfat:ext4:4G \
 && guestfish add $BUILD_DIR/distro.img : run : mount /dev/sda1 / : glob copy-in /mnt/boot/* / : umount / : mount /dev/sda2 / : glob copy-in /mnt/root/* / \
 && sfdisk --part-type $BUILD_DIR/distro.img 1 c

RUN qemu-img convert -f raw -O qcow2 $BUILD_DIR/distro.img $BUILD_DIR/distro.qcow2

RUN mkdir /export

VOLUME ["/export"]

COPY src/main /main
ENTRYPOINT ["main/run"]
