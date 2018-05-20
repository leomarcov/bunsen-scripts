#!/bin/bash

# CHECKS
for p in numix-icon-theme paper-icon-theme bunsen-paper-icon-theme; do
	dpkg -l | egrep "ii *$p" &> /dev/null || { echo "Package $p needed"; exit; } 
done 
[ ! "$list" ] && [ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1

# GENERATE /usr/share/icons/numix-paper dirs
mkdir -v /usr/share/icons/Numix-Paper/
cd /usr/share/icons/Numix-Paper/
cp /usr/share/icons/Numix/index.theme /usr/share/icons/Numix-Paper/
sed -i "s/^Name *= *.*/Name=Numix-Paper/" /usr/share/icons/Numix-Paper/index.theme
sed -i "s/^Inherits *= *.*/Inherits=Numix/" /usr/share/icons/Numix-Paper/index.theme
sed -i "s/^Comment *= *.*/Comment=Theme mix Numix-Paper for BunsenLabs/" /usr/share/icons/Numix-Paper/index.theme
for d in $(find ../Numix/ -type d); do
	[ "$d" == "../Numix" ] && continue
	mkdir -v $(echo $d | sed 's/..\/Numix\///g' ) 
done

echo
read -p "GENERATE PAPER LINKS"
for f in $(ls ../Paper/*/apps/* ../Paper/*/panel/*); do
	ln -svf "../../$f" $(echo "$f" | sed 's/..\/Paper\///g' | sed 's/^[0-9]\+x//g') 2> /dev/null
done
# Change terminator icon for terminal 
for f in $(find . -name "terminator.*"); do
	echo ln -svf "$f" $(echo "$f"  | sed 's/terminator/terminal/g')
done

echo
read -p "GENERATE PAPER-BUNSEN LINKS" 
for f in $(find ../Paper-Bunsen -mindepth 2 -type f); do
	ln -svf "../../$f" $(echo "$f" | sed 's/..\/Paper-Bunsen\///g' | sed 's/^[0-9]\+x//g') 2> /dev/null
done

echo
read -p "GENERATE NUMIX LINKS"
default_color="grey"
for link in $(find ../Numix/ -mindepth 2 -type l); do 
	linked_name=$(basename $(readlink -f "$link"))

	echo "$linked_name" | grep "default" &> /dev/null|| continue
	linked_path=$(dirname $link)/$(echo $linked_name | sed 's/default/'$default_color'/g')
	[ ! -f "$linked_path" ] && continue

	ln -vsf "../../$linked_path" $(echo "$link" | sed 's/..\/Numix\///g')
done



