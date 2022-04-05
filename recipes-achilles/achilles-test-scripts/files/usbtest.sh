#!/bin/sh

echo "Plug an USB key on the USB OTG connector then press [Enter]"
read -s

# Error code initialization
ret=1

sleep 2

#  Check which peripheral file is used by USB key
checkdev=`dmesg | tail -n 5 | grep "[sda]"`
if [ -n "$checkdev" ];then
    echo "The USB Key has been detected"
    ret=0
else
	echo "The USB key has not beed detected as sda peripheral, error !"
	exit $ret
fi 

# Set custom mount point
MOUNT_DIR=/mnt/key
mkdir -p $MOUNT_DIR

# Mount USB key partition
if [ -b "/dev/sda1" ];then
    umount "/dev/sda1"
    mount -t vfat /dev/sda1 ${MOUNT_DIR}
else
    mount -t vfat /dev/sda ${MOUNT_DIR}
fi

# Create test file on USB key
CONTENT="Write test"
echo "${CONTENT}" > "${MOUNT_DIR}/test"
printf "\nTest string written to test file on USB key: $CONTENT\n"

# Read test file
CHECK_CONTENT=`cat ${MOUNT_DIR}/test`
printf "\nReading test string from test file on USB key: $CHECK_CONTENT\n\n"
if [ "${CONTENT}" = "${CHECK_CONTENT}" ];then
    echo "Write test passed."
    ret=0
else
    echo "Write test failed."
    ret=1
fi

# Delete test file
printf "\nDeleting test file on USB key and unmounting...\n\n"
rm -f ${MOUNT_DIR}/test

umount ${MOUNT_DIR}

exit $ret










