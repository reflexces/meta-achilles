#@TYPE: Machine
#@NAME: achilles
#@DESCRIPTION: Common machine configuration for REFLEX CES Achilles Arria 10 SoC SOMs 

require conf/machine/include/socfpga.inc

PREFERRED_VERSION_u-boot-socfpga ?= "v2021.07%"

UBOOT_CONFIG ??= "achilles-${SOM_VER}"

SPL_BINARY = "spl/u-boot-splx4.sfp"
UBOOT_BINARY = "u-boot.img"

KMACHINE = "achilles"

KERNEL_DEVICETREE ?= "socfpga_arria10_achilles.dtb"

PREFERRED_PROVIDER_virtual/kernel = "linux-socfpga-lts"
PREFERRED_VERSION_linux-socfpga-lts = "5.10.%"

SERIAL_CONSOLES ?= "115200;ttyS0"

UBOOT_EXTLINUX ?= "1"
UBOOT_EXTLINUX_LABELS ?= "default"
UBOOT_EXTLINUX_KERNEL_IMAGE:default ?= "../${KERNEL_IMAGETYPE}"
UBOOT_EXTLINUX_KERNEL_ARGS:default ?= "rootwait rw earlycon"
UBOOT_EXTLINUX_ROOT:default ?= "root=/dev/mmcblk0p3"
UBOOT_EXTLINUX_FDT:default ?= "../socfpga_arria10_achilles.dtb"

IMAGE_BOOT_FILES ?= " \
        ${KERNEL_DEVICETREE} \
        ${KERNEL_IMAGETYPE} \
        ${UBOOT_BINARY} \
        extlinux.conf;extlinux/extlinux.conf \
        fit_spl_fpga_periph_only.itb \
        fit_spl_fpga.itb \
        achilles_${SOM_VER}_ghrd.core.rbf \
        "

WKS_FILE ?= "emmcimage-achilles.wks"
IMAGE_FSTYPES +="wic"
