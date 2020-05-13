PR = "r1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/v2019.10:"

SRC_URI = "git://github.com/altera-opensource/u-boot-socfpga.git;branch=socfpga_v2019.10"
SRCREV = "e151fde377cd74153ea8ea94ea34254f9673899c"

SRC_URI_append = "\
	file://0001-add-achilles-support-for-u-boot-socfpga-v2019.10.patch \
	"
