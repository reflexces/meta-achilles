DESCRIPTION = "REFLEX CES Achilles SOM test scripts"
AUTHOR = "Dan Negvesky <dnegvesky@reflexces.com>"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM="file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

SRC_URI = "file://ledtest.sh \
           file://pr_overlay.sh \
           file://mount_fat.sh \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/home/root
    install -m 0755 ${WORKDIR}/ledtest.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/pr_overlay.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/mount_fat.sh ${D}/home/root
}

FILES_${PN} += "/home/root" 
