require recipes-core/images/core-image-minimal.bb

export IMAGE_BASENAME = "achilles-factory-image"

IMAGE_INSTALL += " achilles-factory "

#overload timestamp function in image.bbclass

rootfs_update_timestamp () {
        date -u +%4Y%2m%2d%2H%2M -d "+1 day">${IMAGE_ROOTFS}/etc/timestamp
}

EXPORT_FUNCTIONS rootfs_update_timestamp

