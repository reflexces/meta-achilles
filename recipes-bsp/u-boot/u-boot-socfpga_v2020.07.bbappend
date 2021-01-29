PR = "r1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/v2020.07:"

SRC_URI = "git://github.com/altera-opensource/u-boot-socfpga.git;branch=socfpga_v2020.07"
SRCREV = "ba1c57e617cec2a8179d42d4c5b347f2cc3da634"

SRC_URI_append = "\
	file://0001-add-achilles-support-for-u-boot-socfpga-v2020.07.patch \
	"
