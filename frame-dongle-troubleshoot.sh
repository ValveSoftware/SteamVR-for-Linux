#!/bin/bash

# This is a very quickly-written script to try to track down and spot the most-commonly-seen
# problems with using the Steam Frame wireless dongle on Linux. As new things turn up, the
# script will be revised.
#
# It's written to have the first part of the line easily parsed automatically, for later use;
# the first word will be PROBLEM:<class>: to denote actual problems (and easily surface what 
# type they are, INFO:<class>: for something intended for the user to read, 
# and either FAILURE or SUCCESS on the final line.

echo -- Steam Frame Wireless Dongle Troubleshooting script v0.3
echo --
echo -- Lines beginning with PROBLEM are issues which will prevent the dongle from working.
echo -- Lines beginning with INFO may not prevent the dongle from working, but are worth looking into.
echo ""


# KERNEL/DRIVER CHECKS -------------------------------------------------------

KERNEL_CURRENT=`uname -r | cut -f1 -d '-'`
KERNEL_MAJOR=`echo $KERNEL_CURRENT | cut -f1 -d '.'`
KERNEL_MINOR=`echo $KERNEL_CURRENT | cut -f2 -d '.'`
DRIVER=`lsmod | grep "^rtw"`
PROBLEMS_FOUND=0
FATAL_PROBLEMS=0

# Because the driver IS manually installed on SteamOS even on older kernels -- and could theoretically
# be on other machines -- we'll look for the driver and only check kernel version if the driver isn't
# present.
if [ -z "$DRIVER" ]; then
	if [ $KERNEL_MAJOR -lt 7 ]; then
		echo "PROBLEM:KERNEL: You are on kernel $KERNEL_CURRENT, and must be on kernel 7.2 or later for the driver to be available by default."
		echo ""
		PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
	elif [ $KERNEL_MAJOR -eq 7 ] && [ $KERNEL_MINOR -lt 2 ]; then
		echo "PROBLEM:KERNEL: You are on kernel $KERNEL_CURRENT, and must be on kernel 7.2 or later for the driver to be available by default."
		echo ""
		PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
	else 
		echo "PROBLEM:DRIVER: While you're on a recent enough kernel, the rtw89 driver appears to be missing and may not have been compiled for your distro."
		echo ""
		PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
	fi
fi



# WIFI FUNCTIONALITY CHECKS --------------------------------------------------

WIFI_SOFTBLOCK=`rfkill list wifi | grep 'Soft blocked:' | head -1 | cut -f2 -d ':' | xargs`
WIFI_HARDBLOCK=`rfkill list wifi | grep 'Hard blocked:' | head -1 | cut -f2 -d ':' | xargs`

if [ "$WIFI_SOFTBLOCK" = "yes" ] || [ "$WIFI_HARDBLOCK" = "yes" ]; then
	echo "PROBLEM:WIFI: You have disabled wifi, which will also disable the dongle."
	echo ""
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
fi



# REGULATORY DOMAIN CHECKS ---------------------------------------------------

REG_DOMAIN=`iw reg get | sed -e '/^$/,$d' | grep '^country'`
REG_COUNTRY=`echo $REG_DOMAIN | cut -f1 -d ':' | cut -f2 -d ' '`
REG_RULESET=`echo $REG_DOMAIN | cut -f2 -d ':' | xargs`
REG_BLOCK=`iw reg get | sed -e '/^$/,$d' | tail -n +3`
REG_FEATURES=""
REG_PASSIVESCAN=""
REG_BANDSIZE=0

while IFS= read -r line || [[ -n $line ]]; do
	BAND=`echo $line | cut -f1 -d ',' | xargs`
	FEATURES=`echo $line | cut -f5- -d ',' | xargs`
	BAND_RANGE=`echo $BAND | tr -d '()'`
	BAND_START=`echo $BAND_RANGE | cut -f1 -d ' ' | xargs`
	BAND_END=`echo $BAND_RANGE | cut -f3 -d ' ' | xargs`

	if [ $BAND_START -le 6999 ] && [ $BAND_END -ge 6000 ]; then
		REG_FEATURES=$FEATURES
		REG_PASSIVESCAN=`echo $REG_FEATURES | grep "PASSIVE-SCAN"`
		REG_BANDSIZE=$((BAND_END-BAND_START))
	fi
done < <(printf '%s' "$REG_BLOCK")

if [ $REG_COUNTRY = "00" ] || [ $REG_RULESET = "DFS-UNSET" ]; then
	echo "PROBLEM:REGDOMAIN: Your regulatory domain is set to $REG_COUNTRY and using the $REG_RULESET rules set. Set an appropriate regulatory domain for your location."
	echo ""
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
elif [ -z "$REG_FEATURES" ]; then
	echo "PROBLEM:REGDOMAIN: Your regulatory domain is set to $REG_COUNTRY and using the $REG_RULESET rules set, which seems to lack a 6Ghz band; the dongle will not work."
	echo "PROBLEM:REGDOMAIN: "
	echo "PROBLEM:REGDOMAIN: If $REG_COUNTRY *is* your appropriate regulatory domain, please *do not* just blithely change your regulatory domain"
	echo "PROBLEM:REGDOMAIN: to US (or something similar)! The current recommended workaround is to use USB tethering." 
	echo "PROBLEM:REGDOMAIN: "
	echo "PROBLEM:REGDOMAIN: Put the headset into developer mode (Settings, System, Enable developer mode) and connect to the PC via USB."
	echo "PROBLEM:REGDOMAIN: "
	echo ""
	PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
	FATAL_PROBLEMS=$((FATAL_PROBLEMS + 1))
elif [[ $REG_BANDSIZE -le 900 ]]; then
	echo "INFO:REGDOMAIN: Your regulatory domain is set to $REG_COUNTRY, which does not use the entire 6Ghz band. This is fine, UNLESS the headset has erroneously set itself to the US regulatory domain."
	echo "INFO:REGDOMAIN: Run 'iw reg get' on the *headset's* version of Linux, and if it says 'US' use 'sudo iw reg set $REG_COUNTRY' to correct this."
	echo ""
elif [[ -z $REG_PASSIVESCAN ]]; then
	echo "INFO:REGDOMAIN: Your regulatory domain is set to $REG_COUNTRY and using the $REG_RULESET rules set, and the 6Ghz band only has features $REG_FEATURES; without PASSIVE-SCAN it seems the dongle *may* not work, depending on your distro. (More information on this as we figure out more.)" 
	echo ""
fi



# FIREWALL RULES -------------------------------------------------------------

FIREWALL_ACTIVE=0

if [ -e "`which firewall-cmd`" ]; then
	if [ "`firewall-cmd --state`" = "running" ]; then
		FIREWALL_ACTIVE=1
	fi
elif [ -e "`which ufw`" ]; then
	if [ "`whoami`" = "root" ]; then
		UFW_STATUS=`ufw status numbered | head -1 | cut -f2 -d ' '`
		if [ "$UFW_STATUS" = "active" ]; then
			FIREWALL_ACTIVE=1
		fi
	else
		echo "INFO:FIREWALL: Found ufw (Uncomplicated FireWall) installed, but we aren't root so we can't get firewall status. Skipping check."
		echo ""
	fi	
fi

if [ $FIREWALL_ACTIVE -eq 1 ]; then
	echo "INFO:FIREWALL: "
	echo "INFO:FIREWALL: You appear to have a firewall active on your system, but this script cannot check the rules."
	echo "INFO:FIREWALL: Make sure you have the following ports open, or the Frame and the Steam client won't see each other:"
	echo "INFO:FIREWALL:    TCP: 27036, 27037"
	echo "INFO:FIREWALL:    UDP: 27031, 27036"
	echo "INFO:FIREWALL: In addition, you will need the following ports open for actual VR streaming:"
	echo "INFO:FIREWALL:    UDP: 10400, 10401"
	echo "INFO:FIREWALL: "
	echo "INFO:FIREWALL: It's quite possible you have it running but no real restrictions set, so this may not be a problem!"
	echo "INFO:FIREWALL: "
	echo ""
fi



# SUMMARY --------------------------------------------------------------------

if [ $PROBLEMS_FOUND -eq 0 ]; then
	echo "SUCCESS: None of the most obvious/common problems seem to have turned up!"
elif [ $FATAL_PROBLEMS -gt 0 ]; then
	echo "FAILURE: At least one problem above is technically fatal, and may mean the dongle will simply not work for you."
else
	echo "FAILURE: The problems above will need to be addressed before the dongle will work."
fi
