#!/bin/sh

echo "Enter a date using the format \"2016-11-30 15:40:35\":"
read USERDATE

# Set system time
date -s "$USERDATE"

# Set RTC based on system time
hwclock -w

# Display RTC time
echo -e "\nRTC time:"
hwclock -r

echo -e "\nDoes the RTC displays valid time ? yes/[no]:"
read res

if [ "$res" = "yes" ] || [ "$res" = "y" ];then
	ret=1
else
	echo "RTC test failed!"
	ret=0
fi

exit $ret

