#!/bin/sh

DT_MODEL=`cat /sys/firmware/devicetree/base/model`
BOARD=`echo ${DT_MODEL:?} | cut -d "," -f 2`

WIC_IMAGE="achilles-console-image-${BOARD:?}.wic"

USBKEY="/mnt/key"

mkdir -p ${USBKEY:?}
if [ ! $? -eq 0 ]; then
    logger -s -p user.err "[GUI] - mkdir -p ${USBKEY:?} failed, returned $?"
    exit 42
fi

mount -o ro /dev/sda1 ${USBKEY:?}
if [ ! $? -eq 0 ]; then
    logger -s -p user.err "[GUI] - mount -o ro /dev/sda1 ${USBKEY:?} failed, returned $?"
    exit 42
fi


echo 0 > /proc/sys/kernel/hung_task_timeout_secs


logger -s "Copying WIC image achilles/$BOARD/${WIC_IMAGE:?} from ${USBKEY:?} to eMMC (/dev/mmcblk0)"

dd if=${USBKEY:?}/achilles/$BOARD/${WIC_IMAGE:?} of=/dev/mmcblk0
if [ ! $? -eq 0 ]; then
    logger -s -p user.err "[GUI] - dd if=${USBKEY:?}/achilles/$BOARD/${WIC_IMAGE:?} of=/dev/mmcblk0 failed, returned $?"
    exit 42
fi

sync
umount ${USBKEY:?}
if [ ! $? -eq 0 ]; then
    logger -s -p user.err "[GUI] - umount ${USBKEY:?} failed, returned $?"
    exit 42
fi

poweroff
if [ ! $? -eq 0 ]; then
    logger -s -p user.err "[GUI] - poweroff returned $?"
    exit 42
fi

