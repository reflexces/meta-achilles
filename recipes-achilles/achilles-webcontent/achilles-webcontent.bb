DESCRIPTION = "REFLEX CES Achilles SOM web server home page"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM="file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
PR = "r0"
FILES_${PN} = "/www/pages/*"

SRC_URI += "file://achilles-board-image.png "
SRC_URI += "file://grnled.jpg "
SRC_URI += "file://helper_script.js "
SRC_URI += "file://index.sh "
SRC_URI += "file://not_found.html "
SRC_URI += "file://offled.jpg "
SRC_URI += "file://progress.js "
SRC_URI += "file://redled.jpg "
SRC_URI += "file://reflexces-R-red.png "
SRC_URI += "file://style.css "
SRC_URI += "file://validation_script.js "

S = "${WORKDIR}"

do_install() {
	install -d ${D}/www/pages/cgi-bin
	install -m 0755 achilles-board-image.png ${D}/www/pages/
	install -m 0755 grnled.jpg ${D}/www/pages/
	install -m 0755 helper_script.js ${D}/www/pages/
	install -m 0755 not_found.html ${D}/www/pages/
	install -m 0755 offled.jpg ${D}/www/pages/
	install -m 0755 progress.js ${D}/www/pages/
	install -m 0755 redled.jpg ${D}/www/pages/
	install -m 0755 reflexces-R-red.png ${D}/www/pages/
	install -m 0755 style.css ${D}/www/pages/
	install -m 0755 validation_script.js ${D}/www/pages/
	install -m 0755 index.sh ${D}/www/pages/cgi-bin
}
