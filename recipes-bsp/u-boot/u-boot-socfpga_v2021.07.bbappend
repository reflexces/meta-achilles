FILESEXTRAPATHS:prepend := "${THISDIR}/files/v2021.07:"

DEPENDS:append = " achilles-firmware"

SRC_URI:append = "\
	file://0001-Add-Achilles-V2-support-for-u-boot-socfpga.patch \
	"

SRC_URI:append:achilles-v2-turbo = "\
	file://0002-remove-sdram-size-check.patch \
	"

inherit deploy

do_compile[deptask] = "do_deploy"

do_compile:prepend() {
	cp -r ${DEPLOY_DIR_IMAGE}/hps.xml ${S}/.
	${S}/arch/arm/mach-socfpga/qts-filter-a10.sh ${S}/hps.xml ${S}/arch/arm/dts/socfpga_arria10_achilles_handoff.h
}

do_compile:append:${MACHINE}() {
	cp ${DEPLOY_DIR_IMAGE}/achilles_${SOM_VER}_ghrd.core.rbf ${S}/achilles_${SOM_VER}_ghrd.core.rbf
	cp ${DEPLOY_DIR_IMAGE}/achilles_${SOM_VER}_ghrd.periph.rbf ${S}/achilles_${SOM_VER}_ghrd.periph.rbf
	mkimage -E -f ${S}/board/reflexces/achilles-v2-${SOM_VER}/fit_spl_fpga_periph_only.its ${B}/fit_spl_fpga_periph_only.itb
	mkimage -E -f ${S}/board/reflexces/achilles-v2-${SOM_VER}/fit_spl_fpga.its ${B}/fit_spl_fpga.itb
}

do_deploy:append() {
	install -d ${DEPLOYDIR}
	install -m 744 ${B}/*.itb ${DEPLOYDIR}
	install -m 644 ${B}/${config}/spl/u-boot-splx4.sfp ${DEPLOYDIR}/u-boot-splx4.sfp
}
