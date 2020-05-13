#!/bin/sh

modprobe g_multi file=/usr/share/achilles-usb-gadget/achilles_fat_image.img

sleep 5

#rm /var/lib/misc/udhcpd.leases
/sbin/ifconfig usb0 hw ether 00:01:02:03:0A:10
/sbin/ifconfig usb0 192.168.10.1 netmask 255.255.255.0
/usr/sbin/udhcpd -fS -I 192.168.10.1 /etc/udhcpd.conf
