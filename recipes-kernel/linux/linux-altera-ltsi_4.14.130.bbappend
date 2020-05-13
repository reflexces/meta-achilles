PR = "r0"
FILESEXTRAPATHS_prepend := "${THISDIR}/config:"

SRC_URI_append_achilles += " \
	file://socfpga-4.14.130-ltsi/cfg/usb-gadget.cfg \
	file://socfpga-4.14.130-ltsi/patches/0001-add-achilles-devicetree.patch \
	"

COMPATIBLE_MACHINE = "achilles"
