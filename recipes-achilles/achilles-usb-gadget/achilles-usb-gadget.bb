SUMMARY = "REFLEX CES Achilles SOM Units to initialize USB gadgets"
DESCRIPTION = "REFLEX CES Achilles SOM scripts to start USB gadget for USB mass storage, Ethernet, and serial interfaces"
AUTHOR = "Dan Negvesky <dnegvesky@reflexces.com>"
SECTION = "achilles"

PR = "r1"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit systemd

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH = "${MACHINE_ARCH}"
SRCREV = "${AUTOREV}"
PV = "1.0${PR}+git${SRCPV}"

SRC_URI = "file://achilles-gadget-init.service \
           file://achilles-gadget-init.sh \
           file://udhcpd.conf \
           git://github.com/reflexces/achilles-drivers.git;protocol=https;branch=master \
          "

do_install() {
	install -d ${D}${base_libdir}/systemd/system
	install -m 0644 ${WORKDIR}/*.service ${D}${base_libdir}/systemd/system

	install -d ${D}${sysconfdir}
	install -m 0644 ${WORKDIR}/*.conf ${D}${sysconfdir}

	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/*.sh ${D}${bindir}

	install -d ${D}${sysconfdir}/systemd/system/getty.target.wants
	( cd ${D}${sysconfdir}/systemd/system/getty.target.wants && ln -s /lib/systemd/system/serial-getty@.service serial-getty@ttyGS0.service )

	install -d ${D}${datadir}/${PN}
	tar -xzvf ${WORKDIR}/git/achilles_fat_image.img.tgz --no-same-owner -C ${D}${datadir}/${PN}
}

PACKAGES =+ "${PN}-network ${PN}-udhcpd"

ALLOW_EMPTY:${PN} = "1"

FILES:${PN} = "${base_libdir}/systemd/system/achilles-gadget-init.service \
               ${sysconfdir}/systemd/ \
               ${datadir}/${PN}/ \
               ${datadir}/${PN}/achilles_fat_image.img \
              "

FILES:${PN}-network = "${base_libdir}/systemd/system/network-gadget-init.service \
                       ${bindir}/achilles-gadget-init.sh \
                       ${datadir}/${PN} \
                      "

FILES:${PN}-udhcpd = "${sysconfdir}/udhcpd.conf"

RRECOMMENDS:${PN} = "${PN}-network ${PN}-udhcpd"
RREPLACES:${PN} = "${PN}-storage"


NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "achilles-gadget-init.service"
