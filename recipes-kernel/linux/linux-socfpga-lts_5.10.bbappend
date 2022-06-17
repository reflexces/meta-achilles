FILESEXTRAPATHS:prepend := "${THISDIR}/config:"

KMACHINE:achilles-indus ?= "achilles"
KMACHINE:achilles-lite ?= "achilles"
KMACHINE:achilles-turbo ?= "achilles"

COMPATIBLE_MACHINE:achilles-indus = "achilles-indus"
COMPATIBLE_MACHINE:achilles-lite = "achilles-lite"
COMPATIBLE_MACHINE:achilles-turbo = "achilles-turbo"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI:append:${MACHINE} = " \
	file://socfpga-5.10-lts/cfg/pcf8563.cfg \
	file://socfpga-5.10-lts/cfg/tmp102.cfg \
	file://socfpga-5.10-lts/cfg/usb-gadget.cfg \
	file://socfpga-5.10-lts/patches/0001-add-achilles-devicetree.patch \
	file://lbdaf.scc \
	file://socfpga-5.10-lts/devicetree-overlay/achilles_ghrd_base.dtso \
	file://socfpga-5.10-lts/devicetree-overlay/achilles_sysid.dtso \
	file://socfpga-5.10-lts/devicetree-overlay/blink_led_default.dtso \
	file://socfpga-5.10-lts/devicetree-overlay/blink_led_fast.dtso \
	file://socfpga-5.10-lts/devicetree-overlay/blink_led_slow.dtso \
	"
inherit deploy

do_compile:append:${MACHINE}() {
	if ${@bb.utils.contains("GHRD_TYPE", "pr", "true", "false", d)}; then
#		cd ${WORKDIR}
		install -m 0644 ${WORKDIR}/socfpga-5.10-lts/devicetree-overlay/achilles_ghrd_base.dtso ${S}/arch/arm/boot/dts/achilles_ghrd_base.dts
		install -m 0644 ${WORKDIR}/socfpga-5.10-lts/devicetree-overlay/achilles_sysid.dtso ${S}/arch/arm/boot/dts/achilles_sysid.dts
		install -m 0644 ${WORKDIR}/socfpga-5.10-lts/devicetree-overlay/blink_led_default.dtso ${S}/arch/arm/boot/dts/blink_led_default.dts
		install -m 0644 ${WORKDIR}/socfpga-5.10-lts/devicetree-overlay/blink_led_fast.dtso ${S}/arch/arm/boot/dts/blink_led_fast.dts
		install -m 0644 ${WORKDIR}/socfpga-5.10-lts/devicetree-overlay/blink_led_slow.dtso ${S}/arch/arm/boot/dts/blink_led_slow.dts
		make achilles_ghrd_base.dtb achilles_sysid.dtb blink_led_default.dtb blink_led_fast.dtb blink_led_slow.dtb
    fi
}

do_deploy:append:${MACHINE}() {
	if ${@bb.utils.contains("GHRD_TYPE", "pr", "true", "false", d)}; then
		install -d ${DEPLOY_DIR_IMAGE}/devicetree
		install -m 0644 ${B}/arch/arm/boot/dts/*.dtb ${DEPLOY_DIR_IMAGE}/devicetree
    fi
}

addtask deploy after do_compile
