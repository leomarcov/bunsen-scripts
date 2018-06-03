#!/bin/bash
#===================================================================================
# BRIGHTNESS INC/DEC
# FILE: brightness.sh
#
# DESCRIPTION: Inc/dec the brightness  in small steps
#
# AUTHOR: Leonardo Marco
# VERSION: 1.0
# CREATED: 30.06.2018 
#===================================================================================

# CONFIG
bl_step=5					# Percent steps of inc/dec
bl_min=5					# Minium percent brightness
bl_default="30"					# Default percent
bl_dir="/sys/class/backlight/intel_backlight/"	# Dir for control backlight
install_path="/usr/bin/brightness.sh"		# Installation dir

#=== FUNCTION ==================================================================
# NAME: help
# DESCRIPTION: Show command help
#===============================================================================
function help() {
	echo -e 'Inc/dec the brightness
Usage: '$(basename $0)' -inc|-dec|-h|-I|-U
   \e[1m-h\e[0m\tShow command help
   \e[1m-def\e[0m\tSet brightness to '"$default"%'
   \e[1m-inc\e[0m\tIncrease the brightness in '"%bl_step"'%"
   \e[1m-dec\e[0m\tDecrease the brightness in '"%bl_step"'%"
'
	exit 0
}

function set_brightness() {
	[ "$1" -eq "$1" ] &> /dev/null || return
	bl_max="$(cat "$bl_dir/max_brightness")"
	bl_min="$(($bl_max*$bl_min/100))"
	
	if [ "$bl_next" -ge "$bl_max" ]; then
		bl_next="$bl_max"
	elif [ "$bl_next" -lt "$bl_min" ]; then
		bl_next="$bl_min"
	fi
	
	echo "$bl_next" > "$bl_dir/brightness"
}

function change_brightness() {
	bl_current="$(cat "$bl_dir/brightness")"
	bl_max="$(cat "$bl_dir/max_brightness")"

	case "$1" in
	"-def") 
		bl_next="$(($bl_max*$bl_default/100))"
		;;
	"-inc"|"-dec")
		bl_step="$(($bl_max*$bl_step/100))"
		[ "$1" = "-dec" ] && bl_step="-$bl_step"
		bl_next="$(($bl_step+$bl_current))"
	esac
	set_brightness "$bl_next"
}


if [ ! -d "$bl_dir" ]; then
	echo "$bl_dir dont exist"
	echo "Please contig bl_dir in $0 file"
	exit 1
fi

[ "$1" != "-dec" ] && [ "$1" != "-inc" ] && [ "$1" != "-def" ] && help
change_brightness "$1"
