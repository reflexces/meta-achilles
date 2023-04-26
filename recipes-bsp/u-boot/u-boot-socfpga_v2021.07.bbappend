FILESEXTRAPATHS:prepend := "${THISDIR}/files/v2021.07:"

DEPENDS:append = " achilles-firmware"

SRC_URI:append:achilles-v2 = " file://0001-Add-Achilles-V2-support-for-u-boot-socfpga.patch"

SRC_URI:append:achilles-v2-turbo = " file://0002-remove-sdram-size-check.patch"


SRC_URI:append:achilles-v5 = " \
	file://0001-Add-Achilles-V5-support-for-u-boot-socfpga.patch \
	file://0002-remove-sdram-size-check.patch \
"

inherit deploy

def is_factory_build(d):
    import re

    if re.match(".*factory", d.getVar('MACHINE')):
        return "true"
    else:
        return "false"

do_compile[depends] += "achilles-firmware:do_deploy"

do_compile:prepend() {
	cp -r ${DEPLOY_DIR_IMAGE}/hps.xml ${S}/hps.xml
	${S}/arch/arm/mach-socfpga/qts-filter-a10.sh ${S}/hps.xml ${S}/arch/arm/dts/socfpga_arria10_achilles_handoff.h
}

# FPGA boot seems to be no longer supported after U-Boot v2014.10
#do_compile:append() {
#	if "${@is_factory_build(d)}"; then
#		arm-poky-linux-gnueabi-objcopy -I binary -O ihex --adjust-vma -0x00000000 ${B}/${config}/u-boot-with-spl.bin ${B}/${config}/hpsBootTarget_u-boot-with-spl.hex
#	fi
#}

do_compile:append() {
	cp ${DEPLOY_DIR_IMAGE}/achilles_${SOM_REV}_${SOM_VER}_ghrd.core.rbf ${S}/achilles_${SOM_REV}_${SOM_VER}_ghrd.core.rbf
	cp ${DEPLOY_DIR_IMAGE}/achilles_${SOM_REV}_${SOM_VER}_ghrd.periph.rbf ${S}/achilles_${SOM_REV}_${SOM_VER}_ghrd.periph.rbf
	mkimage -E -f ${S}/board/reflexces/achilles-${SOM_REV}-${SOM_VER}/fit_spl_fpga_periph_only.its ${B}/fit_spl_fpga_periph_only.itb
	mkimage -E -f ${S}/board/reflexces/achilles-${SOM_REV}-${SOM_VER}/fit_spl_fpga.its ${B}/fit_spl_fpga.itb
}

do_deploy:append() {
	install -d ${DEPLOYDIR}
	install -m 744 ${B}/*.itb ${DEPLOYDIR}
	if ! "${@is_factory_build(d)}"; then
		install -d ${DEPLOYDIR}
		install -m 644 ${B}/${config}/spl/u-boot-splx4.sfp ${DEPLOYDIR}/u-boot-splx4.sfp
#	else
#		install -m 644 ${B}/${config}/hpsBootTarget_u-boot-with-spl.hex ${DEPLOYDIR}/hpsBootTarget.hex
	fi
}
