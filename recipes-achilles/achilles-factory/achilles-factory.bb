DESCRIPTION = "REFLEX CES Achilles SOM factory scripts"
AUTHOR = "Delbegue C <cdelbegue@reflexces.com>"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM="file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

SRC_URI = "file://partitionning.sh"

do_install() {
	install -d ${D}/home/root
	install -m 0755 ${WORKDIR}/partitionning.sh ${D}/home/root/

	touch ${D}/home/root/.profile
	echo "/home/root/partitionning.sh" >> ${D}/home/root/.profile
}

FILES:${PN} += " \
	/home/root/partitionning.sh \
	/home/root/.profile \
"
