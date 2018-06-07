#!/bin/bash
#===================================================================================
# Shutdown machine if nobody is logged since minutes in firs parameter (or defined in script)
# AUTHOR: Leonardo Marco
# CREATED: 2018.06.07
#===================================================================================

default_mins=20  # Wait mins if $1 is empty

function try_poweroff() {
  mins="$1"
  ! [ "$1" -eq "$1" ] &>/dev/null && mins="$default_mins"
  
  # Exit if someone is logged
  [ "$(who | wc -l)" -gt 0 ] && exit 

  # Exit if someone was logged 20min ago
  [ $(last -s -${mins}min | grep -Ev 'reboot|wtmp|^$' | wc -l) -gt 0 ] && exit

  # Poweroff the machine
  shutdown -h now
}

function install() {

}

function help() {
	echo -e 'Shutdown machine if nobody is logged since minutes in first parameter.
Usage: '$(basename $0)' [min] | [-I]
   \e[1m-I\e[0m\tInstall the script (copy and program cron every '$default_mins'minutes
   \e[1mmin\e[0m\tMinutes for wait until try poweroff (default '$default_mins')
'
	exit 0
}

case "$1" in
  -I)         install       ;;
  ""|[0-9]+)  try_poweroff  ;;
  *)          help          ;;
esac
