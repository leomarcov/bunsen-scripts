#!/bin/bash

dpkg -l numix-icon-theme &> /dev/null || sudo apt-get install numix-icon-theme
dpkg -l paper-icon-theme &> /dev/null || sudo apt-get install paper-icon-theme
dpkg -l bunsen-paper-icon-theme &> /dev/null || sudo apt-get install bunsen-paper-icon-theme



[ ! "$list" ] && [ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1
mkdir /usr/share/icons/Numix-Bunsen


read -p "GENERATE PAPER-BUNSEN LINKS" 
for f in $(find ../Paper-Bunsen -type f); do
	ln -sv "../../$f" $(echo "$f" | sed 's/..\/Paper-Bunsen\///g' | sed 's/^[0-9]\+x//g') 2> /dev/null
done


read -p "GENERATE PAPER LINKS"
for f in $(ls ../Paper/*/apps/*); do
	ln -sv "../../$f" $(echo "$f" | sed 's/..\/Paper\///g' | sed 's/^[0-9]\+x//g') 2> /dev/null
done


read -p "GENERATE NUMIX LINKS"
default_color="grey"
for link in $(find ../Numix/ -type l); do 
	linked_name=$(basename $(readlink -f "$link"))

	echo "$linked_name" | grep "default" &> /dev/null|| continue
	linked_path=$(dirname $link)/$(echo $linked_name | sed 's/default/'$default_color'/g')
	[ ! -f "$linked_path" ] && continue

	ln -vs "../../$linked_path" $(echo "$link" | sed 's/..\/Numix\///g')
done



