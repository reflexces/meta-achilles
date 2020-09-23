SUMMARY = "Firmware for REFLEX CES Achilles SOM"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit deploy

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRCREV_FORMAT = "hardware"
SRCREV_hardware = "${AUTOREV}"

PV="${PN}+git${SRCPV}"

SRC_URI += " \
	git://github.com/reflexces/achilles-hardware.git;destsuffix=hardware;name=hardware;protocol=https;branch=ghrd-v20.1-pr \
"

do_install () {
	cd ${WORKDIR}/hardware
	install -d ${D}${base_libdir}/firmware
	install -m 0644 output_files/achilles_ghrd.pr_partition.rbf ${D}${base_libdir}/firmware
	install -m 0644 output_files/blink_led_default.pr_partition.rbf ${D}${base_libdir}/firmware
	install -m 0644 output_files/blink_led_fast.pr_partition.rbf ${D}${base_libdir}/firmware
	install -m 0644 output_files/blink_led_slow.pr_partition.rbf ${D}${base_libdir}/firmware
	install -m 0644 devicetree/achilles_ghrd_base.dtbo ${D}${base_libdir}/firmware
	install -m 0644 devicetree/achilles_sysid.dtbo ${D}${base_libdir}/firmware
	install -m 0644 devicetree/blink_led_default.dtbo ${D}${base_libdir}/firmware
	install -m 0644 devicetree/blink_led_fast.dtbo ${D}${base_libdir}/firmware
	install -m 0644 devicetree/blink_led_slow.dtbo ${D}${base_libdir}/firmware
}

do_deploy () {
	cd ${WORKDIR}/hardware
	install -d ${DEPLOYDIR}
	install -m 0644 output_files/fit_spl_fpga_periph_only.itb ${DEPLOYDIR}
	install -m 0644 output_files/fit_spl_fpga.itb ${DEPLOYDIR}
	install -m 0644 output_files/achilles_ghrd.core.rbf ${DEPLOYDIR}
}

addtask deploy after do_install

FILES_${PN} += "${base_libdir}/firmware" 
