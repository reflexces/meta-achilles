PR = "r0"
FILESEXTRAPATHS_prepend := "${THISDIR}/config:"

# socfpga-5.4.74-lts
SRCREV = "f8f8365913778a80bdc3ddd8548b85298b4588bc"

SRC_URI_append_achilles += " \
	file://socfpga-5.4-lts/cfg/usb-gadget.cfg \
	file://socfpga-5.4-lts/patches/0001-add-achilles-devicetree.patch \
	"

COMPATIBLE_MACHINE = "achilles"
