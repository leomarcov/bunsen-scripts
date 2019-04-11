#!/bin/bash
# ACTION: Config Thunar for show toolbar and double-click for active items
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"
	
for d in  /usr/share/bunsen/skel/.config/xfce4/xfconf/xfce-perchannel-xml/  /home/*/.config/xfce4/xfconf/xfce-perchannel-xml/ ; do
	cp -v "$base_dir/postinstall-files/thunar.xml" "$d"
done

