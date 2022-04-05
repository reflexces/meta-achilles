#! /bin/sh

MEMSIZE=`cat /proc/meminfo | grep MemAvailable | awk -F ' ' '{print $2}'`
MEMSIZE=$((MEMSIZE/1024))

# Accepted format : 
# - g/G for Gigabytes
# - m/M for MegaBytes
# - k/K for KiloBytes
# - b/B for Bytes 
printf "\nStarting memory test.  This can take up to 30 minutes...\n\n"
memtester ${MEMSIZE}M 1
