#!/bin/sh

GREEN_LED=2033
RED_LED=2034

# Export GPIOs
echo $GREEN_LED > /sys/class/gpio/export
echo $RED_LED > /sys/class/gpio/export

# Set GPIO direction
echo "out" > /sys/class/gpio/gpio${GREEN_LED}/direction
echo "out" > /sys/class/gpio/gpio${RED_LED}/direction

# Turn off the LEDs
echo 1 > /sys/class/gpio/gpio${GREEN_LED}/value
echo 1 > /sys/class/gpio/gpio${RED_LED}/value

# Turn on then turn off successively all the LEDs
for i in `seq 0 1 1`; do
    echo 0 > /sys/class/gpio/gpio${GREEN_LED}/value
    sleep 1s
    echo 0 > /sys/class/gpio/gpio${RED_LED}/value
    sleep 1s
    echo 1 > /sys/class/gpio/gpio${RED_LED}/value
    sleep 1s
    echo 1 > /sys/class/gpio/gpio${GREEN_LED}/value
    sleep 1s
done

for i in `seq 0 1 3`; do
	res=$((i%2))
	# Turn off the LEDs
	if [ $res -gt 0 ];then
		echo 1 > /sys/class/gpio/gpio${GREEN_LED}/value
		echo 1 > /sys/class/gpio/gpio${RED_LED}/value
	# Turn on the LEDs
	else
		echo 0 > /sys/class/gpio/gpio${GREEN_LED}/value
		echo 0 > /sys/class/gpio/gpio${RED_LED}/value
	fi
	sleep 1s
done

# Unexport GPIOs
echo $GREEN_LED > /sys/class/gpio/unexport
echo $RED_LED > /sys/class/gpio/unexport
