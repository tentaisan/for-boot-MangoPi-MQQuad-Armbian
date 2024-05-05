FROM ubuntu:24.04

COPY files/ /opt/

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    build-essential \
    bison \
    flex \
    swig \
    python3-setuptools \
    python-dev-is-python3 \
    libssl-dev \
    gcc-aarch64-linux-gnu

RUN cd /opt/ \
    && git clone https://github.com/ARM-software/arm-trusted-firmware.git -b v2.10.0 --depth 1 \
    && cd arm-trusted-firmware \
    && make CROSS_COMPILE=aarch64-linux-gnu- PLAT=sun50i_h616 DEBUG=1 bl31 

RUN cd /opt/ \
    && git clone https://gitlab.com/u-boot/u-boot.git -b v2024.04 --depth 1 \
    && cp /opt/mangopi_mq_quad_defconfig u-boot/configs \
    && cp /opt/sun50i-h616-mangopi-mq-quad.dts u-boot/arch/arm/dts/ \
    && cd u-boot \
    && make CROSS_COMPILE=aarch64-linux-gnu- BL31=../arm-trusted-firmware/build/sun50i_h616/debug/bl31.bin mangopi_mq_quad_defconfig \
    && make CROSS_COMPILE=aarch64-linux-gnu- BL31=../arm-trusted-firmware/build/sun50i_h616/debug/bl31.bin

RUN cd /opt/ \
    && mkdir result \
    && cp u-boot/u-boot-sunxi-with-spl.bin u-boot/arch/arm/dts/sun50i-h616-mangopi-mq-quad.dtb result/ \
    && rm -rf u-boot arm-trusted-firmware