#!/bin/bash

#=== FUNCTION ==================================================================
# NAME: help
# DESCRIPTION: Show command help
#===============================================================================
function help() {
	echo -e 'Install configs and themes after BunsenLabs '"$bunsen_ver"' installation
Usage: '$(basename $0)' [-h] [-l] [-a <actions>] [-y] [-d]
   \e[1m-l\e[0m\t\tOnly list actions 
   \e[1m-a <actions>\e[0m\tOnly do selected actions (e.g: -a 5,6,10-15)
   \e[1m-y\e[0m\t\tAuto-answer yes to all actions
   \e[1m-d\e[0m\t\tAuto-answer default to all actions
   \e[1m-h\e[0m\t\tShow this help'
	exit 0
}


#=== FUNCTION ==================================================================
# NAME: ask_action
# DESCRIPTION: show question to do an action and determine if do it or not do
# EXIT CODE: 
#	0-> do the action
#	1-> dont do de action
#===============================================================================
n=0
function ask_action() {
	action="$1"
	info="$2"
	default="${3,,}"
	[ "$default" != "n" ] && default="y"
	n=$((n+1))

	[ "$actions" ] && { echo "$actions" | grep -w "$n" &> /dev/null || return 1; } 
	[ "$list" ] && echo -e "[$n] $action" && return 1

	[ "${default,,}" = "y" ] && q="(Y/n)?" || q="(y/N))?"

	echo -en "\n\e[33m${info}\n\e[39m\e[1m[$n] \e[4m${action}\e[0m $q "
	case "$yes" in
		allyes) 	q="y"; echo	"$q"		;;
		default) 	q="$default"; echo "$q"	;;
		*)	 		read q					;;
	esac
	
	[ "${q,,}" != "n" ] && return 0
	return 1
}



#=== PARAMS ====================================================================
while getopts ":hlyda:" o; do
	case "$o" in
	h)	help 			;;
	l)	list="true"		;;
	y)	yes="allyes"	;;
	d)	yes="default"	;;
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
# Check root:
[ ! "$list" ] && [ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1


#=== EXEC-ACTIONS ==============================================================
base_dir="$(dirname "$(readlink -f "$0")")"
scripts_dir="$base_dir/postinstall-scripts/"

n=0
for script in "$scripts_dir"/[0-9]*; do
	head="$(head -10 "$script")"
	action="$(echo "$head" | grep "#[[:blank:]]*ACTION:" | sed 's/#[[:blank:]]*ACTION:[[:blank:]]*//')"
	[ ! "action" ] && continue
	info="$(echo "$head" | grep "#[[:blank:]]*INFO:" | sed 's/#[[:blank:]]*INFO:[[:blank:]]*//')"
	default="$(echo "$head" | grep "#[[:blank:]]*DEFAULT:" | sed 's/#[[:blank:]]*DEFAULT:[[:blank:]]*//')"

	if ask_action "$action" "$info" "$default"; then
		"$script"		# EXEC SCRIPT
	fi
	echo
done

if [ ! "$list" ] && [ ! "$actions" ] && ask_action "Reboot" "" "n"; then 
	reboot
fi
echo
