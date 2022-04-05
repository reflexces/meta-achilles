FILESEXTRAPATHS:prepend := "${THISDIR}/config:"

COMPATIBLE_MACHINE = "achilles"

SRC_URI:append:achilles += " \
	file://socfpga-5.10-lts/cfg/pcf8563.cfg \
	file://socfpga-5.10-lts/cfg/tmp102.cfg \
	file://socfpga-5.10-lts/cfg/usb-gadget.cfg \
	file://socfpga-5.10-lts/patches/0001-add-achilles-devicetree.patch \
	file://lbdaf.scc \
	"
    
