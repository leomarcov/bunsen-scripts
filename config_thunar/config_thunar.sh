#!/bin/bash
# ACTION: Config Thunar for show toolbar and double-click for active items
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

base_dir="$(dirname "$(readlink -f "$0")")"
	
for d in /usr/share/bunsen/skel/.config/xfce4/xfconf/xfce-perchannel-xml/  /home/*/.config/xfce4/xfconf/xfce-perchannel-xml/ ; do
	cp -v "$base_dir/thunar.xml" "$d"
done

