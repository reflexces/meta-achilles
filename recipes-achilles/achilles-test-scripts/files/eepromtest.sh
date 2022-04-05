#!/bin/sh

single_test()
{
	read -r -p "Enter data value to write (Example: 0x##): " -i "0x" -e w_data
	while ! [[ $w_data =~ ^0x[0-9A-Fa-f][0-9A-Fa-f]$ ]]; do
	   echo "Write data is not in the correct format.  Please re-enter in format of '0x##': "
	   read -i "0x" -e w_data
	done

	read -r -p "Enter address between 0x00 and 0xFF to write (Example: 0x##): " -i "0x" -e w_addr
	while ! [[ $w_addr =~ ^0x[0-9A-Fa-f][0-9A-Fa-f]$ ]]; do
	   echo "Write address is not in the correct format or is out of range.  Please re-enter in format of '0x##': "
	   read -i "0x" -e w_addr
	done

	i2cset -y 0 0x54 $w_addr $w_data
	sleep 0.5
	i2cdump -y -r 0x0-0xFF 0 0x54 b

	while true
	do
		printf "\n"
		read -r -p "Does data read match data written? [yes/no] " response
		case "$response" in
			[yY][eE][sS]|[yY]) 
				printf "\nEEPROM Test PASSED!\n\n"
				break
			;;
			[nN][oO]|[nN]) 
				printf "\nEEPROM Test FAILED!\n\n"
				break
			;;
			*)
				printf "\nInvalid entry.\n"
			;;
		esac
	done
}

full_test()
{
	read -r -p "Enter data value to write (Example: 0x##): " -i "0x" -e w_data
	while ! [[ $w_data =~ ^0x[0-9A-Fa-f][0-9A-Fa-f]$ ]]; do
	   echo "Write data is not in the correct format.  Please re-enter in format of '0x##': "
	   read -i "0x" -e w_data
	done

	for i in {0..15}
	do
		hex_i=$(printf "%#x" ${i})
		i2ctransfer -y 0 w17@0x54 ${hex_i}0 ${w_data}= 
	done

	sleep 0.5
	i2cdump -y -r 0x0-0xFF 0 0x54 b
	
	while true
	do
		printf "\n"
		read -r -p "Does data read match data written? [yes/no] " response
		case "$response" in
			[yY][eE][sS]|[yY]) 
				printf "\nEEPROM Test PASSED!\n\n"
				break
			;;
			[nN][oO]|[nN]) 
				printf "\nEEPROM Test FAILED!\n\n"
				break
			;;
			*)
				printf "\nInvalid entry.\n"
			;;
		esac
	done
}

printf "\n"
printf "**********************************\n"
printf "I2C 2Kbit EEPROM Test Menu:       \n"
printf "**********************************\n"
printf " 1 = Write/Read Single Address    \n"
printf " 2 = Write/Read Full EEPROM       \n"
printf "**********************************\n"
echo -e ${NC}

while true
	do
		read -r -p "Enter EEPROM Test to run (choose only one option): " choice
		case "$choice" in
			1)
				until single_test ; do : ; done
				break
			;;
			2)
				until full_test ; do : ; done
				break
			;;
			*)
				printf "\nInvalid entry.\n\n"
			;;
		esac
	done
