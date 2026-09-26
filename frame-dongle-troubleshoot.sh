#!/bin/bash

# This is a very quickly-written script to try to track down and spot the most-commonly-seen
# problems with using the Steam Frame wireless dongle on Linux. As new things turn up, the
# script will be revised.
#
# It's written to have the first part of the line easily parsed automatically, for later use;
# the first word will be PROBLEM:<class>: to denote actual problems (and easily surface what 
# type they are, and either FAILURE or SUCCESS on the final line.

echo -- Steam Frame Wireless Dongle Troubleshooting script v0.1



# KERNEL/DRIVER CHECKS -------------------------------------------------------

KERNEL_CURRENT=`uname -r | cut -f1 -d '-'`
KERNEL_MAJOR=`echo $KERNEL_CURRENT | cut -f1 -d '.'`
KERNEL_MINOR=`echo $KERNEL_CURRENT | cut -f2 -d '.'`
DRIVER=`lsmod | grep "^rtw"`
PROBLEMS_FOUND=0

if [ $KERNEL_MAJOR -lt 7 ]; then
	echo "PROBLEM:KERNEL: You are on kernel $KERNEL_CURRENT, and must be on kernel 7.2 or later."
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
elif [ $KERNEL_MAJOR -eq 7 ] && [ $KERNEL_MINOR -lt 2 ]; then
	echo "PROBLEM:KERNEL: You are on kernel $KERNEL_CURRENT, and must be on kernel 7.2 or later."
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
elif [ -z "$DRIVER" ]; then
	echo "PROBLEM:DRIVER: You're on kernel $KERNEL_CURRENT, but it seems to be missing the Realtek rtw89 driver needed for the dongle."
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
fi



# WIFI FUNCTIONALITY CHECKS --------------------------------------------------

WIFI_SOFTBLOCK=`rfkill list wifi | grep 'Soft blocked:' | head -1 | cut -f2 -d ':' | xargs`
WIFI_HARDBLOCK=`rfkill list wifi | grep 'Hard blocked:' | head -1 | cut -f2 -d ':' | xargs`

if [ "$WIFI_SOFTBLOCK" = "yes" ] || [ "$WIFI_HARDBLOCK" = "yes" ]; then
	echo "PROBLEM:WIFI: You have disabled wifi, which will also disable the dongle."
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
fi



# REGULATORY DOMAIN CHECKS ---------------------------------------------------

REG_DOMAIN=`iw reg get | sed -e '/^$/,$d' | grep '^country'`
REG_COUNTRY=`echo $REG_DOMAIN | cut -f1 -d ':' | cut -f2 -d ' '`
REG_RULESET=`echo $REG_DOMAIN | cut -f2 -d ':' | xargs`
REG_BLOCK=`iw reg get | sed -e '/^$/,$d' | tail -n +3`
REG_FEATURES=""
REG_PASSIVESCAN=""

while IFS= read -r line || [[ -n $line ]]; do
	BAND=`echo $line | cut -f1 -d ',' | xargs`
	FEATURES=`echo $line | cut -f5- -d ',' | xargs`
	BAND_RANGE=`echo $BAND | tr -d '()'`
	BAND_START=`echo $BAND_RANGE | cut -f1 -d ' ' | xargs`
	BAND_END=`echo $BAND_RANGE | cut -f3 -d ' ' | xargs`

	if [ $BAND_START -le 6999 ] && [ $BAND_END -ge 6000 ]; then
		REG_FEATURES=$FEATURES
		REG_PASSIVESCAN=`echo $REG_FEATURES | grep "PASSIVE-SCAN"`
	fi
done < <(printf '%s' "$REG_BLOCK")

if [ $REG_COUNTRY = "00" ] || [ $REG_RULESET = "DFS-UNSET" ]; then
	echo "PROBLEM:REGDOMAIN: Your regulatory domain is set to $REG_COUNTRY and using the $REG_RULESET rules set. Set an appropriate regulatory domain."
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
elif [ -z "$REG_FEATURES" ]; then
	echo "PROBLEM:REGDOMAIN: Your regulatory domain is set to $REG_COUNTRY and using the $REG_RULESET rules set, which seems to lack a 6Ghz band; the dongle will not work."
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
elif [[ -z $REG_PASSIVESCAN ]]; then
	echo "PROBLEM:REGDOMAIN: Your regulatory domain is set to $REG_COUNTRY and using the $REG_RULESET rules set, and the 6Ghz band only has features $REG_FEATURES; without PASSIVE-SCAN the dongle may not work." 
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
fi



# SUMMARY --------------------------------------------------------------------

if [ $PROBLEMS_FOUND -eq 0 ]; then
	echo "SUCCESS: None of the most obvious/common problems seem to have turned up!"
else
	echo "FAILURE: The problems above will need to be addressed."
fi
