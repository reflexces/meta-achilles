require recipes-images/angstrom/achilles-extended-console-image.bb

IMAGE_INSTALL += " \
"
export IMAGE_BASENAME = "achilles-console-image"

#overload timestamp function in image.bbclass

rootfs_update_timestamp () {
        date -u +%4Y%2m%2d%2H%2M -d "+1 day">${IMAGE_ROOTFS}/etc/timestamp
}

EXPORT_FUNCTIONS rootfs_update_timestamp

# add these back in under IMAGE_INSTALL when these recipes are developed
#	achilles-fpga-init \
#	achilles-lighttpd-conf \
#	achilles-linux-firmware \
#	achilles-usb-gadget \
#	achilles-webcontent \
#	achilles-x11vnc-init \
#	achilles-xfce-default-config \
#	achilles-xfce-init \
#
# ERROR: Nothing RPROVIDES error message on these packages
#	iperf \
#
# carry-over from Chameleon96	
#	achilles-fpga-leds \
