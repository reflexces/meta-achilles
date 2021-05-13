require recipes-images/poky/achilles-extended-console-image.bb

IMAGE_INSTALL += " \
	achilles-firmware \
	achilles-fpga-init \
	achilles-lighttpd-conf \
	achilles-test-scripts \
	achilles-usb-gadget \
	achilles-webcontent \
"
export IMAGE_BASENAME = "achilles-console-image"

#overload timestamp function in image.bbclass

rootfs_update_timestamp () {
        date -u +%4Y%2m%2d%2H%2M -d "+1 day">${IMAGE_ROOTFS}/etc/timestamp
}

EXPORT_FUNCTIONS rootfs_update_timestamp

# add these to file achilles-xfce-image.bb under IMAGE_INSTALL when these recipes are developed
#	achilles-x11vnc-init \
#	achilles-xfce-default-config \
#	achilles-xfce-init \
