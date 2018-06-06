#!/bin/bash

default_mins=20  # Wait mins for poweroff if no user logged
mins="$1"
! [ "$1" -eq "$1" ] &>/dev/null && mins="$default_mins"

# Exit if someone is logged
[ "$(who | wc -l)" -gt 0 ] && exit 

# Exit if someone was logged 20min ago
[ $(last -s -${mins}min | grep -Ev 'reboot|wtmp|^$' | wc -l) -gt 0 ] && exit

# Poweroff the machine
shutdown -h now
