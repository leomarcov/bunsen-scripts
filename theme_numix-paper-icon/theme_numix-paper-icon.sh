#!/bin/bash
# ACTION: Install Numix-Paper icon theme and set as default
# INFO: Numix-Paper is a icon theme based on Numix and Paper icon themes.
# DEFAULT: y

base_dir="$(dirname "$(readlink -f "$0")")"
icon_default="Numix-Paper"

find /var/cache/apt/pkgcache.bin -mtime 0 &>/dev/null ||  apt-get update  
apt-get install -y numix-icon-theme paper-icon-theme bunsen-paper-icon-theme

if [ ! -d /usr/share/icons/Numix/ ]; then
	echo "$(basename $0) ERROR: Numix theme is not installed"
	exit 1
fi

unzip -o "$base_dir"/numix-paper-icon-theme.zip -d /usr/share/icons/	
	
for f in  /usr/share/bunsen/skel/.gtkrc-2.0  /home/*/.gtkrc-2.0 ; do
	sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'"$icon_default"'"/' "$f"		
done
for f in  /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini  /home/*/.config/gtk-3.0/settings.ini ; do
	sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name='"$icon_default"'/' "$f"
done
