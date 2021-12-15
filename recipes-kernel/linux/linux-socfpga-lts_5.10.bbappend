FILESEXTRAPATHS_prepend := "${THISDIR}/config:"

COMPATIBLE_MACHINE = "achilles"

SRC_URI_append_achilles += " \
	file://socfpga-5.10-lts/cfg/usb-gadget.cfg \
	file://socfpga-5.10-lts/patches/0001-add-achilles-devicetree.patch \
	file://lbdaf.scc \
	"
    
