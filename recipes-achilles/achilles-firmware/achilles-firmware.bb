SUMMARY = "Firmware for REFLEX CES Achilles SOM"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRCREV_FORMAT = "hardware"
SRCREV_hardware = "${AUTOREV}"

PV="${PN}+git${SRCPV}"

SRC_URI += " \
	git://github.com/dnegvesky/achilles-hardware.git;destsuffix=hardware;name=hardware;protocol=https;branch=beta-build-test \
"

do_install () {
	cd ${WORKDIR}/hardware
	install -d ${D}${base_libdir}/firmware
	install -m 0644 fit_spl_fpga_periph_only.itb ${D}
	install -m 0644 fit_spl_fpga.itb ${D}
#	install -m 0644 output_files/achilles_ghrd.core.rbf ${D}${base_libdir}/firmware
	install -m 0644 achilles_ghrd.core.rbf ${D}${base_libdir}/firmware
	install -m 0644 devicetree/achilles.dtbo ${D}${base_libdir}/firmware
}

do_deploy () {
	cd ${WORKDIR}/hardware
	install -d ${DEPLOYDIR}
	install -m 0644 fit_spl_fpga_periph_only.itb ${DEPLOYDIR}
	install -m 0644 fit_spl_fpga.itb ${DEPLOYDIR}
#	install -m 0644 output_files/achilles_ghrd.core.rbf ${DEPLOYDIR}
	install -m 0644 achilles_ghrd.core.rbf ${DEPLOYDIR}
}

addtask deploy after do_install

FILES_${PN} += "${base_libdir}/firmware" 
