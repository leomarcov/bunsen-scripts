#!/bin/bash
#=== SCRIPT CONFIGS ============================================================
bunsen_ver="Helium"
openbox_default="GoHomeV2-leo"
wallpaper_default="bl-colorful-aptenodytes-forsteri-by-nixiepro.png"
comment_auto="#BL-POSTINSTALL"
vb_package="virtualbox-5.2"
ep_url="https://download.virtualbox.org/virtualbox/5.2.12/Oracle_VM_VirtualBox_Extension_Pack-5.2.12.vbox-extpack"   #https://www.virtualbox.org/wiki/Downloads


#=== FUNCTION ==================================================================
# NAME: help
# DESCRIPTION: Show command help
#===============================================================================
function help() {
	echo -e 'Install configs and themes after BunsenLabs '"$bunsen_ver"' installation
Usage: '$(basename $0)' [-h] [-l] [-a <actions>]
   \e[1m-l\e[0m\t\tOnly list actions 
   \e[1m-a <actions>\e[0m\tOnly do selected actions (e.g: -a 5,6,10-15)
   \e[1m-y\e[0m\t\tAuto-answer yes to all actions
   \e[1m-h\e[0m\t\tShow this help'
	exit 0
}


#=== FUNCTION ==================================================================
# NAME: do_action
# DESCRIPTION: Show question to do an action and determine if do or not
# EXIT CODE: 0 if should be do de action, 1 in other case
#===============================================================================
n=0
function do_action() {
	n=$((n+1))
	[ "$actions" ] && { echo "$actions" | grep -w "$n" &> /dev/null || return 1; } 
	q="$1"
	[ "$list" ] && echo -e "[$n] $q" && return 1

	echo -en "\n\e[1m[$n] \e[4m$q\e[0m (Y/n)? "
	[ "$yes" ] && q="y" || read q 
	[ "${q,,}" != "n" ] && return 0
	return 1
}

#=== PARAMS ====================================================================
while getopts ":hla:y" o; do
	case "$o" in
	h)	help 		;;
	l)	list="true"	;;
	y)	yes="true"	;;
	a)	for a in $(echo "$OPTARG" | tr "," " "); do
			# Is a range
			echo "$a" | grep -E "[0-9]"*-"[0-9]" &> /dev/null && actions="$actions $(eval echo {$(echo $a|sed "s/-/../")})"
			# Is a number 
			[ "$a" -eq 0 ] &>/dev/null; [ $? -le 1 ] && actions="$actions $a"
		done			
		;;
	esac
done


#=== CHECKS ===================================================================
[ ! "$list" ] && [ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1
if [ ! "$list" ] && ! cat /etc/*release 2>/dev/null| grep "CODENAME" | grep -i "$bunsen_ver" &> /dev/null; then
	echo "Seems you are not running BunsenLabs $bunsen_ver"
	echo "Some packages may fail. Cross your fingers and press enter..."
	read
fi
[ -f /sys/module/battery/initstate ] || [ -d /proc/acpi/battery/BAT0 ] && laptop="true"
cat /proc/cpuinfo | grep -i hypervisor &>/dev/null && virtualmachine="true"
current_dir="$(dirname "$(readlink -f "$0")")"


#=== EXEC-ACTIONS ==============================================================
base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"
scripts_dir="$basedir/postinstall-scripts/"
for s in "$basedir"/[0-9]*; do
	head="$(head -8 "$scripts_dir")"
	action="$(echo "$head" | grep "#[[:blank:]]*ACTION:" | awk '{print $3}' )"
	
done



# reboot
if [ ! "$list" ] && [ ! "$actions" ] && do_action "Reboot" ; then 
	reboot
fi

