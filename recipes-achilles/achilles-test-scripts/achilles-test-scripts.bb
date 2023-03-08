DESCRIPTION = "REFLEX CES Achilles SOM test scripts"
AUTHOR = "Dan Negvesky <dnegvesky@reflexces.com>"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM="file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

RDEPENDS:${PN} += "lmsensors"
RDEPENDS:${PN} += "memtester"
RDEPENDS:${PN} += "python3-datetime"

SRC_URI = "file://eepromtest.sh \
           file://ledtest.sh \
           file://memtest.sh \
           file://mount_fat.sh \
           file://pr_overlay.sh \
           file://rtctest.sh \
           file://tempsensortest.sh \
           file://usbtest.sh \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/home/root
    install -m 0755 ${WORKDIR}/eepromtest.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/ledtest.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/memtest.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/mount_fat.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/rtctest.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/tempsensortest.sh ${D}/home/root
    install -m 0755 ${WORKDIR}/usbtest.sh ${D}/home/root

    if ${@bb.utils.contains("GHRD_TYPE", "pr", "true", "false", d)}; then
        install -m 0755 ${WORKDIR}/pr_overlay.sh ${D}/home/root
    fi
}

FILES:${PN} += "/home/root" 
