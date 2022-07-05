#!/bin/sh
#  Copyright (C) 2020 REFLEX CES
#
#  This program is free software; you can redistribute it and/or modify it
#  under the terms and conditions of the GNU General Public License,
#  version 2, as published by the Free Software Foundation.
#
#  This program is distributed in the hope it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program.  If not, see <http://www.gnu.org/licenses/>.

# This is a quick hack from the Intel dev kit webpage.  The intention is to demo the
# webserver and create a simple home page (not ideal to use a bash script) and some
# simple interaction with the board LEDs, FPGA system ID, and on board temperature
# sensor. Beware, the LED stuff is buggy.  - DN

MACHINE=$(hostname)

case $MACHINE in
	achilles-indus)
		DEVKIT_NAME="REFLEX CES Achilles Indus Arria 10 SoC SOM"
	;;
	achilles-lite)
		DEVKIT_NAME="REFLEX CES Achilles Lite Arria 10 SoC SOM"
	;;
	achilles-turbo)
		DEVKIT_NAME="REFLEX CES Achilles Turbo Arria 10 SoC SOM"
	;;
	comxpress)
		DEVKIT_NAME="REFLEX CES COMXpress Stratix 10 Module"
	;;
	*)
	DEVKIT_NAME="Unknown Development Kit"
		exit -1
	;;
esac

SYSTEM_ID_INFO="<a href=\"https://github.com/reflexces/achilles-hardware/blob/ghrd-v22.1/system_id_info.txt\" target=\"_blank\">system_id_info.txt</a> "

echo -e "Content-type: text/html"
echo ""
echo -e "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \".w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
echo -e "<html xmlns=\".w3.org/1999/xhtml\" xmlns:mso=\"urn:schemas-microsoft-com:office:office\" xmlns:msdt=\"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882\">"
echo -e "<head>"
echo -e "<title>Board Interface Web Page: $DEVKIT_NAME</title>"
echo -e "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
echo -e "<link rel=\"stylesheet\" media=\"all\" type=\"text/css\" href=\"../style.css\" />"
echo -e "<script src=\"../progress.js\" type=\"text/javascript\"></script>"
echo -e "<script src=\"../helper_script.js\" type=\"text/javascript\"></script>"
echo -e "<script src=\"../validation_script.js\" type=\"text/javascript\"></script>"

echo -e "<!--[if gte mso 9]><xml>"
echo -e "<mso:CustomDocumentProperties>"
echo -e "<mso:ContentType msdt:dt=\"string\">Document</mso:ContentType>"
echo -e "</mso:CustomDocumentProperties>"
echo -e "</xml><![endif]-->"

echo -e "</head>"

echo -e "<body class=\"body-container\" onload=\"start()\">"
echo -e "<div class=\"bup-header\">"
echo -e "<img src=\"../reflexces-R-red.png\" alt=\"REFLEX R\" style=\"float:left; padding:15px 0px 15px 10px;\"/>"
echo -e "<div class=\"bup-header-right\"><span>Board Interface Web Page</span><br/>"
echo -e $DEVKIT_NAME
echo -e "</div>"
echo -e "</div>"
echo -e "<div class=\"bup-content\">"
echo -e "<div class=\"bup-form\">"
echo -e "<span><strong><h1>Overview</h1></strong><br/>"
echo -e "</span>"
echo -e "<p>This Board Interface web page is being served by the web server application running on the Hard Processor System (HPS) on this development board. You can use this web page to interact with your board by blinking the LEDs, reading the temperature, and reading the System ID."
echo -e "</div>"

if [ "$MACHINE" == "achilles-indus" ] || [ "$MACHINE" == "achilles-lite" ] || [ "$MACHINE" == "achilles-turbo" ]; then
	echo -e "<div class=\"bup-links\">"
	echo -e "<h4>Developer Resources</h4>"
	echo -e "<ul>"
	echo -e "<li><a href=\"https://www.reflexces.com\" target=\"_blank\">REFLEX CES Webpage</a></li> "
	echo -e "<li><a href=\"https://www.altera.com/products/soc/soc-quick-start-guide/arria10soc-dev-kit-quick-start.html\" target=\"_blank\">Arria 10 SoC Quick Start Guide</a></li> "
	echo -e "<li><a href=\"https://www.altera.com/products/fpga/arria-series/arria-10/support.html\" target=\"_blank\">Hardware Resources</a></li> "
	echo -e "<li><a href=\"https://www.altera.com/products/soc/portfolio/arria-10-soc/design-tools.html\" target=\"_blank\">Software Resources</a></li> "
	echo -e "<li><a href=\"http://www.rocketboards.org\" target=\"_blank\">Rocketboards.org</a></li> "
	echo -e "</ul>"
	echo -e "</div>"
elif [ "$MACHINE" == "comxpress" ]; then
	echo -e "<div class=\"bup-links\">"
	echo -e "<h4>Developer Resources</h4>"
	echo -e "<ul>"
	echo -e "<li><a href=\"https://www.reflexces.com\" target=\"_blank\">REFLEX CES Webpage</a></li> "
	echo -e "<li><a href=\"https://www.altera.com/products/soc/soc-quick-start-guide/stratix10soc-dev-kit-quick-start.html\" target=\"_blank\">Stratix 10 SoC Quick Start Guide</a></li> "
	echo -e "<li><a href=\"https://www.altera.com/products/fpga/stratix-series/Stratix-10/support.html\" target=\"_blank\">Hardware Resources</a></li> "
	echo -e "<li><a href=\"https://www.altera.com/products/soc/portfolio/stratix-10-soc/design-tools.html\" target=\"_blank\">Software Resources</a></li> "
	echo -e "<li><a href=\"http://www.rocketboards.org\" target=\"_blank\">Rocketboards.org</a></li> "
	echo -e "</ul>"
	echo -e "</div>"
fi

echo -e "<div class=\"bup-form\">"
echo "<hr style=\"border: 1px solid; color:#06c\"><br>"

if [ "$MACHINE" == "achilles-indus" ] || [ "$MACHINE" == "achilles-lite" ] || [ "$MACHINE" == "achilles-turbo" ]; then
	echo -e "<span><strong><h1>$DEVKIT_NAME Features</h1></strong><br/>"
	echo -e "<div><img src=\"../achilles-board-image.png\" style=\"width:640px;height:478px;\"></div>"
elif [ "$MACHINE" == "comxpress" ]; then
	echo -e "<span><strong><h1>$DEVKIT_NAME Features</h1></strong><br/></span>"
	echo -e "<div><img src=\"../comxpress-board-image.png\" style=\"width:640px;height:478px;\"></div>"
fi

echo -e "<div id=\"interactive\" class=\"bup-form\">"
echo "<hr style=\"border: 1px solid; color:#06c\"><br>"
echo -e "<span><strong><h1>Interacting with $DEVKIT_NAME</h1></strong><br/>"
echo -e "</span>"

read POST_STRING
SCROLL_DELAY=-1
LED_CONTROL=-1
LED_COMMAND="none"
LED_FREQ=-1

IFS='&' read -ra ADDR <<< "$POST_STRING"

#enable GRN/RED LED GPIO so we can use them later
echo 2033 > /sys/class/gpio/export
echo 2034 > /sys/class/gpio/export
#set the HPS GPIO2 bits driving the LEDs to OUT
#HPS GPIO2 base address = 0xFFC02b00
devmem 0xFFC02B04 32 0x3000
# turn the LEDs off
#devmem 0xFFC02B00 32 0x3000

for i in "${ADDR[@]}"
do
	KEY=`echo $i | sed 's/=.*//g'`
	VALUE=`echo $i | sed 's/.*=//g'`

	if [ "$KEY" = "scroll_freq" ]; then
		SCROLL_DELAY=$VALUE
	fi

	if [ "$KEY" = "scroll" ]; then
		if [ "$VALUE" = "START" ]; then
			SCROLL_COMMAND="start"
		fi
		if [ "$VALUE" = "STOP" ]; then
			SCROLL_COMMAND="stop"
		fi
	fi

	for LED_NUMBER in 0 1
	do
		if [ "$KEY" = "led_"$LED_NUMBER ]; then
			if [ "$VALUE" = "BLINK" ]; then
				LED_CONTROL=$LED_NUMBER
				LED_COMMAND="blink"
			fi
			if [ "$VALUE" = "OFF" ]; then
				LED_CONTROL=$LED_NUMBER
				LED_COMMAND="off"
			fi
			if [ "$VALUE" = "ON" ]; then
				LED_CONTROL=$LED_NUMBER
				LED_COMMAND="on"
			fi
		fi

	done

	if [ "$KEY" = "led_0_freq" ]; then
		LED_FREQ=$VALUE
	fi
	if [ "$KEY" = "led_1_freq" ]; then
		LED_FREQ=$VALUE
	fi
	if [ "$KEY" = "scroll_freq" ]; then
		SCROLL_FREQ=$VALUE
	fi
done

if [ "$LED_CONTROL" != "-1" ]; then
#	if [ "$LED_COMMAND" = "blink" ]; then
	while [ "$LED_COMMAND" = "blink" ]; do
		if [ "$LED_CONTROL" = "0" ]; then
			WR_VAL=0x2000        
			STATE=`devmem 0xFFC02B00 32`
			devmem 0xFFC02B00 32 $(($STATE & $WR_VAL))
			sleep $LED_FREQ
			WR_VAL=0x1000
			devmem 0xFFC02B00 32 $(($STATE | $WR_VAL))
			sleep $LED_FREQ
		else
			WR_VAL=0x1000        
			STATE=`devmem 0xFFC02B00 32`
			devmem 0xFFC02B00 32 $(($STATE & $WR_VAL))
			sleep $LED_FREQ
			WR_VAL=0x2000
			devmem 0xFFC02B00 32 $(($STATE | $WR_VAL))
			sleep $LED_FREQ
		fi		
#	fi
	done

	if [ "$LED_COMMAND" = "on" ]; then
		if [ "$LED_CONTROL" = "0" ]; then
			WR_VAL=0x2000
		else
			WR_VAL=0x1000
		fi

		STATE=`devmem 0xFFC02B00 32`
		devmem 0xFFC02B00 32 $(($STATE & $WR_VAL)) 
	fi
	
	if [ "$LED_COMMAND" = "off" ]; then
		if [ "$LED_CONTROL" = "0" ]; then
			WR_VAL=0x1000
		else
			WR_VAL=0x2000
		fi

		STATE=`devmem 0xFFC02B00 32`
		devmem 0xFFC02B00 32 $(($STATE | $WR_VAL)) 
	fi
fi

if [ "$SCROLL_COMMAND" = "start" ]; then
	source /home/root/ledtest.sh
fi

#ON=1, OFF=0, BLINK=-1
LED0_STATUS=0
LED1_STATUS=0

SCROLL_START=0

#LED0_BLINKING=`cat /sys/class/leds/fpga_led0/trigger | cut -d "[" -f2 | cut -d "]" -f1`
#LED1_BLINKING=`cat /sys/class/leds/fpga_led1/trigger | cut -d "[" -f2 | cut -d "]" -f1`

if [ "$LED0_BLINKING" = "timer" ]; then
	LED0_STATUS=-1
else
	LED0_STATUS=`cat /sys/class/gpio/gpio2033/value`
fi

if [ "$LED1_BLINKING" = "timer" ]; then
	LED1_STATUS=-1
else
	LED1_STATUS=`cat /sys/class/gpio/gpio2034/value`
fi

SCROLL_START=`./scroll_client 0`

if [ $SCROLL_START -ge 1 ]; then
	SCROLL_START=1
else
	SCROLL_START=0
fi

echo -e "<p>You can observe the LEDs that are connected to the FPGA on the board from the picture below.</p>"

echo -e "<table style=\"margin-top:10px; margin-left:0px; font-family: Arial; font-size: 10pt\">"
echo -e "<tr><td></td><td align=center width=19 height=10>0</td> <td align=center width=19 height=10>1</td></tr>"
echo -e "<tr>"

if [ "$SCROLL_START" == "1" ]; then
	echo -e "<td align=left ><strong>LED Status:</strong> </td> <td align=center colspan=4><img src=\"../runningled.gif\"></td>"
else
	echo -e "<td><strong>LED Status:</strong></td>"
	if [ "$LED0_STATUS" == "1" ]; then
		echo -e "<td align=center width=19 height=46> <img src=\"../offled.jpg\"> </td>"
    elif [ "$LED0_STATUS" == "0" ]; then
		echo -e "<td align=center width=19 height=46> <img src=\"../grnled.jpg\"> </td>"
	else
		echo -e "<td align=center width=19 height=46> <img src=\"../offled.jpg\"> </td>"
	fi

	if [ "$LED1_STATUS" == "1" ]; then
		echo -e "<td align=center width=19 height=46> <img src=\"../offled.jpg\"> </td>"
	elif [ "$LED1_STATUS" == "0" ]; then
		echo -e "<td align=center width=19 height=46> <img src=\"../redled.jpg\"> </td>"
	else
		echo -e "<td align=center width=19 height=46> <img src=\"../offled.jpg\"> </td>"
	fi
fi

echo -e "</tr>"
echo -e "</table>"

echo "<br><hr style=\"border: 1px dotted\"><br>"


echo -e "<p>You can start running a short \"lightshow\" on the LEDs that are connected to the HPS GPIO. Click Start button and the show will run for approximately 10 seconds.<br><br></p>"

echo -e "<FORM name=\"interactive\" action=\"/cgi-bin/index.sh#interactive\" method=\"post\">"


echo -e "<P>"
echo -e "<strong><font size=\"2\"> LED Lightshow: </font></strong> "
#echo -e "<INPUT type=\"text\" id=\"lightshow\" class=\"box\" size=\"22\" name=\"scroll_freq\" onChange=\"valuevalidation(this.value, 0);\" placeholder=\"Type LED Running Delay (ms)\">"
#echo -e "<INPUT type=\"submit\" class=\"box\" name=\"scroll\" value=\"START\" onclick=\"if(validatedelay()) return this.clicked  = true; else return this.clicked = false;\">"
echo -e "<INPUT type=\"submit\" class=\"box\" name=\"scroll\" value=\"START\" >"
#echo -e "<INPUT type=\"submit\" class=\"box\" name=\"scroll\" value=\"STOP\" >"
echo -e "</P>"

echo -e "</FORM>"

echo "<br>"

echo "<hr style=\"border: 1px dotted\">"

echo -e "<p><br>You can turn on, turn off, or blink the LEDs that are connected to the HPS GPIO on the development kit. To blink the LEDs, type the LED toggling delay in seconds (decimals allowed, e.g. 0.5) and click Blink button.<br><br></p>"
#echo -e "<span><strong><h1>debug: KEY = $KEY</h1></strong><br/>"
#echo -e "<span><strong><h1>debug: LED COMMAND = $LED_COMMAND</h1></strong><br/>"
#echo -e "<span><strong><h1>debug: LED CONTROL = $LED_CONTROL</h1></strong><br/>"
#echo -e "<span><strong><h1>debug: SCROLL START = $SCROLL_START</h1></strong><br/>"
#echo -e "<span><strong><h1>debug: SCROLL COMMAND = $SCROLL_COMMAND</h1></strong><br/>"
#echo -e "<span><strong><h1>debug: VALUE = $VALUE</h1></strong><br/>"
#echo -e "<span><strong><h1>debug: LED0 STATUS = $LED0_STATUS</h1></strong><br/>"

echo -e "<FORM action=\"/cgi-bin/index.sh#interactive\" method=\"post\">"
echo -e "<P>"
echo -e "<strong><font size=\"2\"> GRN LED: </font></strong> "	
if [ "$SCROLL_START" == 0 ]; then
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_0\" value=\"ON\" >"
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_0\" value=\"OFF\" >"
	echo -e "&nbsp &nbsp &nbsp &nbsp &nbsp"
#	echo -e "<INPUT type=\"text\" id=\"led0_id\" class=\"box\" size=\"22\" name=\"led_0_freq\" placeholder=\"Type LED Toggling Delay (sec)\" onChange=\"valuevalidation(this.value, 1);\">  " 	
	echo -e "<INPUT type=\"text\" id=\"led0_id\" class=\"box\" size=\"22\" name=\"led_0_freq\" placeholder=\"Type LED Toggling Delay (sec)\" >"
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_0\" value=\"BLINK\" >"
else
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_0\" value=\"ON\" disabled>"
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_0\" value=\"OFF\" disabled>"
	echo -e "&nbsp &nbsp &nbsp &nbsp &nbsp"
	echo -e "<INPUT type=\"text\" id=\"led0_id\" class=\"box\" size=\"22\" name=\"led_0_freq\" placeholder=\"Type LED Toggling Delay (sec)\"  disabled>  "
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_0\" value=\"BLINK\" disabled>"
fi	
echo -e "</P>"
echo -e "</FORM>"

echo -e "<FORM action=\"/cgi-bin/index.sh#interactive\" method=\"post\">"
echo -e "<P>"
   echo -e "<strong><font size=\"2\"> RED LED: </font></strong> "	
if [ "$SCROLL_START" == 0 ]; then
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_1\" value=\"ON\" >"
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_1\" value=\"OFF\" >"	
	echo -e "&nbsp &nbsp &nbsp &nbsp &nbsp"
#	echo -e "<INPUT type=\"text\" id=\"led1_id\" class=\"box\" size=\"22\" name=\"led_1_freq\" placeholder=\"Type LED Toggling Delay (sec)\" onChange=\"valuevalidation(this.value, 2);\">  "
	echo -e "<INPUT type=\"text\" id=\"led1_id\" class=\"box\" size=\"22\" name=\"led_1_freq\" placeholder=\"Type LED Toggling Delay (sec)\" >"
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_1\" value=\"BLINK\" >"
else
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_1\" value=\"ON\" disabled>"
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_1\" value=\"OFF\" disabled>"	
	echo -e "&nbsp &nbsp &nbsp &nbsp &nbsp"
	echo -e "<INPUT type=\"text\" id=\"led1_id\" class=\"box\" size=\"22\" name=\"led_1_freq\" placeholder=\"Type LED Toggling Delay (sec)\" disabled>  "
	echo -e "<INPUT type=\"submit\" class=\"box\" name=\"led_1\" value=\"BLINK\" disabled>"
fi	
echo -e "</P>"
echo -e "</FORM>"

# SSH connection
#CONST_IP_CHECK_RETRIES=10
#RETRY_COUNT=1
#while [ $RETRY_COUNT -le ${CONST_IP_CHECK_RETRIES} ]
#; do
	IP=`ifconfig eth0 | head -n 2 | tail -n 1 | sed s/inet\ // | sed s/\ netmask.*// | sed s/\ *//g`
#	IP_CHECK=`echo $IP | sed 's/\(\([0-9]\{1,3\}\)\.\)\{3\}\([0-9]\{1,3\}\)//g'`
#	if [ "$IP_CHECK" != "" ]; then
#		IP="No IP obtained"
#		sleep 1
#	else
#		RETRY_COUNT=$((${CONST_IP_CHECK_RETRIES} + 1))
#	fi
#	RETRY_COUNT=$((${RETRY_COUNT} + 1))
#done

echo -e "<br> <hr style=\"border: 1px solid; color:#06c\"> <br>"
echo -e "<span><strong><h1>Connect to Linux Console on board over SSH Connection</h1></strong><br>"
echo -e "<p>You may connect your host system to SSH server running on the board using the IP address shown below. In your host system terminal, type the following:<br><br> <font face="courier, arial" size="3">ssh root@$IP</font></p>"
echo -e "<p>You must have an SSH client installed in your host system. If SSH is not available, install the openssh package on your host.</p>"
echo -e "<p>When the SSH connection is established, you can run various test scripts located in /home/root.</p>"
 
# GHRD System ID
SYS_ID=`devmem 0xFF200000 32`
echo -e "<br> <hr style=\"border: 1px solid; color:#06c\"> <br>"
echo -e "<span><strong><h1>Achilles GHRD System ID</h1></strong><br>"
echo -e "<p>The Achilles GHRD System ID stores information about the hardware revision and feature options enabled in the design.<br><br><font face="courier, arial" size="3">GHRD System ID = $SYS_ID</font></p>"
echo -e "<p>To decode the information stored in the System ID, refer to the $SYSTEM_ID_INFO file.</p>"

echo -e "</div>"

echo -e "</div>"

echo -e "<div class=\"footer-gutter\"></div>"

echo -e "<div class=\"footer-container-blur\">"
echo -e "<div class=\"footer-container-shadow\">"
echo -e "<div id=\"footer\" class=\"footer-container\">"

echo -e "<div id=\"footerCopyright\" class=\"footer-copyright\">"
echo -e "<p align=\"center\" style=\"width:900px; font-size:9px;\">Copyright &copy; 2022 REFLEX CES. All Rights Reserved.<br/>"
echo -e "</div>"
echo -e "</div>"
echo -e "</div>"

echo -e "</body>"
echo -e "</html>"

