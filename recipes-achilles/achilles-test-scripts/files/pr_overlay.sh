#!/bin/sh
#
# MIT License
# Copyright (c) 2020 REFLEX CES
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Author: Dan Negvesky <dnegvesky@reflexces.com>
# Contributors:
#
# Release info:
#
# 2020.09.16
#
##################################################################################
# Test script to apply and remove Achilles GHRD partial reconfiguration
# overlays.  Demonstrates the application of overlays used to reconfigure
# a PR region on the Arria 10 SoC FPGA on the Achilles SOM.  The software
# build automatically includes three different PR region persona overlay
# binaries (.dtbo) to demonstrate the kernel overlay feature:
# 1. blink_led_default = the HPS red LED blinks every 0.67 sec
#    This is the default loaded by u-boot during the initial boot process
# 2. blink_led_fast = the HPS red LED blinks every 0.34 sec
# 3. blink_led_slow = the HPS red LED blinks every 1.34 sec
#
# Valid for linux kernel version socfpga-4.14.130-ltsi.
##################################################################################

OVERLAY_DIR=/sys/kernel/config/device-tree/overlays/active_persona

usage()
{
    echo "Usage: ./pr_overlay [options]"
    echo "Apply Achilles GHRD example PR region overlays"
    echo "Options:"
    echo "  -d, --default        Apply the blink_led_default.dtbo overlay."
    echo "                       The HPS red LED blinks every 0.67 sec."
    echo ""
    echo "  -f, --fast           Apply the blink_led_fast.dtbo overlay."
    echo "                       The HPS red LED blinks every 0.34 sec."
    echo ""
    echo "  -s, --slow           Apply the blink_led_slow.dtbo overlay."
    echo "                       The HPS red LED blinks every 1.34 sec."
    echo ""
    echo "  -h, --help           Display this help message and exit."
    echo ""
}

if [ $# -eq 0 ]
  then
    echo ""
    echo "No arguments supplied."
    echo ""
    usage
    exit 1
else
    case $1 in
        -d | --default)
            SPEED=default
        ;;
        -f | --fast)
            SPEED=fast
        ;;
        -s | --slow)
            SPEED=slow
        ;;
        -h | --help)
            usage
            exit
        ;;
        *)
            usage
            exit 1
    esac
#    shift
fi

# check if any of the ghrd example pr_region overlays were previously applied and remove them

if [ -d "$OVERLAY_DIR" ]; then rmdir $OVERLAY_DIR; fi

# apply the overlay specified by the command line arguement

mkdir $OVERLAY_DIR
echo blink_led_$SPEED.dtbo > $OVERLAY_DIR/path
