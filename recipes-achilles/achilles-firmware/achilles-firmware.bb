SUMMARY = "Firmware for REFLEX CES Achilles SOM"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit deploy

DEPENDS = "virtual/kernel"
PACKAGE_ARCH = "${MACHINE_ARCH}"

SRCREV_FORMAT = "hardware"
SRCREV_hardware = "${AUTOREV}"
SRCREV = "${AUTOREV}"

SRC_URI += " \
	git://github.com/reflexces/achilles-hardware.git;destsuffix=hardware;name=hardware;protocol=https;branch=ghrd-v22.1 \
"

# nothing to install if GHRD_TYPE = "std"
ALLOW_EMPTY:${PN} = "1"

do_install[deptask] = "do_deploy"

do_install () {
	if ${@bb.utils.contains("GHRD_TYPE", "pr", "true", "false", d)}; then
		install -d ${D}${base_libdir}/firmware
		install -m 0644 ${WORKDIR}/hardware/precompiled/rbf/${MACHINE}/blink_led_default.pr_partition.rbf ${D}${base_libdir}/firmware
		install -m 0644 ${WORKDIR}/hardware/precompiled/rbf/${MACHINE}/blink_led_fast.pr_partition.rbf ${D}${base_libdir}/firmware
		install -m 0644 ${WORKDIR}/hardware/precompiled/rbf/${MACHINE}/blink_led_slow.pr_partition.rbf ${D}${base_libdir}/firmware
		install -m 0644 ${DEPLOY_DIR_IMAGE}/devicetree/achilles_ghrd_base.dtb ${D}${base_libdir}/firmware/achilles_ghrd_base.dtbo
		install -m 0644 ${DEPLOY_DIR_IMAGE}/devicetree/achilles_sysid.dtb ${D}${base_libdir}/firmware/achilles_sysid.dtbo
		install -m 0644 ${DEPLOY_DIR_IMAGE}/devicetree/blink_led_default.dtb ${D}${base_libdir}/firmware/blink_led_default.dtbo
		install -m 0644 ${DEPLOY_DIR_IMAGE}/devicetree/blink_led_fast.dtb ${D}${base_libdir}/firmware/blink_led_fast.dtbo
		install -m 0644 ${DEPLOY_DIR_IMAGE}/devicetree/blink_led_slow.dtb ${D}${base_libdir}/firmware/blink_led_slow.dtbo
	fi
}

do_deploy () {
	cd ${WORKDIR}/hardware
	install -d ${DEPLOY_DIR_IMAGE}
	install -m 0644 precompiled/hps_isw_handoff/${MACHINE}/hps.xml ${DEPLOY_DIR_IMAGE}
	install -m 0644 precompiled/rbf/${MACHINE}/achilles_${SOM_VER}_ghrd.periph.rbf ${DEPLOY_DIR_IMAGE}
	install -m 0644 precompiled/rbf/${MACHINE}/achilles_${SOM_VER}_ghrd.core.rbf ${DEPLOY_DIR_IMAGE}
}

addtask deploy after do_install

FILES:${PN} += "${base_libdir}/firmware"
