COMPATIBLE_MACHINE = "achilles"

SRC_URI_append_achilles += " \
	file://socfpga-5.4-lts/cfg/usb-gadget.cfg \
	file://socfpga-5.4-lts/patches/0001-add-achilles-devicetree.patch \
	file://lbdaf.scc \
	"
