#@TYPE: Machine
#@NAME: achilles-factory
#@DESCRIPTION: Factory machine configuration for REFLEX CES Achilles Arria 10 SoC SOMs

require conf/machine/include/socfpga.inc

PREFERRED_VERSION_u-boot-socfpga ?= "v2021.07%"

UBOOT_CONFIG ??= "boot-from-fpga"

UBOOT_SUFFIX = "sfp"
UBOOT_BINARY = "u-boot-with-spl.${UBOOT_SUFFIX}"

KMACHINE ?= "achilles-factory"

PREFERRED_PROVIDER_virtual/kernel = "linux-socfpga-lts"
PREFERRED_VERSION_linux-socfpga-lts = "5.10.%"

KERNEL_IMAGETYPE = "zImage"

SERIAL_CONSOLES ?= "115200;ttyS0"

EXTRA_IMAGEDEPENDS += "u-boot-socfpga"

INITRAMFS_IMAGE = "achilles-factory-image"
INITRAMFS_IMAGE_BUNDLE = "1"
