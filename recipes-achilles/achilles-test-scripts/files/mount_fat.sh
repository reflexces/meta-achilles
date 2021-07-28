#!/bin/sh
# script to mount the FAT partition so new files can be copied from build host PC to eMMC

mkdir -p /media/emmcp1
mount -t vfat /dev/mmcblk0p1 /media/emmcp1
cd /media/emmcp1 
