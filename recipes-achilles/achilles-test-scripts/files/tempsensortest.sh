#!/bin/sh

echo "Trying to get sensor temperature...."

sensors

echo -e "\nDo you see in prevous traces a valid sensor temperature ? yes/[no]:"
read res

if [ "$res" = "yes" ] || [ "$res" = "y" ];then
	ret=1
else
	echo "Temperature sensor test failed!"
	ret=0
fi

exit $ret

