#!/bin/bash
#===================================================================================
# BRIGHTNESS INC/DEC
# FILE: brightness.sh
#
# DESCRIPTION: Inc/dec the brightness
#
# AUTHOR: Leonardo Marco
# VERSION: 1.0
# CREATED: 16.05.2018 
# LAST-UPDATE: 16.05.2018 
#===================================================================================

# CONFIG
step=5										# Steps of inc/dec
video_id="eDP-1"							# Video ID
install_path="/usr/bin/brightness.sh"		# Installation dir
default="0.6"

#=== FUNCTION ==================================================================
# NAME: help
# DESCRIPTION: Show command help
#===============================================================================
function help() {
	echo -e 'Inc/dec the brightness
Usage: '$(basename $0)' -inc|-dec|-h|-I|-U
   \e[1m-h\e[0m\tShow command help
   \e[1m-def\e[0m\tSet default brightness ('"$default"')
   \e[1m-inc\e[0m\tIncrease the brightness
   \e[1m-dec\e[0m\tDecrease the brightness
   \e[1m-I\e[0m\tInstall the script
   \e[1m-U\e[0m\tUninstall the script
	'
	exit 0
}

function set_brightness() {
	xrandr --output "$video_id" --brightness "$1"
	exit
}

function change_brightness() {
	b=($(xrandr --verbose | awk  '/Brightness/ { print $2; }' | tr "." " "))
	b=$((${b[0]}*100+${b[1]}))

	n=0
	[ "$1" = "-dec" ] && n=-$step
	[ "$1" = "-inc" ] && n=+$step

	b=$(($n+$b))

	if [ "$b" -ge 100 ]; then
		b="1.0"
	elif [ "$b" -lt 20 ]; then
		b="0.20"
	else
		b="0.${b}"
	fi

	xrandr --output "$video_id" --brightness "$b"

	exit
}


[ "$1" = "-dec" ] || [ "$1" = "-inc" ] && change_brightness "$1"
[ "$#" -eq 0 ] && exit 
[ "$1" = "-def" ] && set_brightness "$default"

help


