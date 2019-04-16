#!/bin/bash
# ACTION: Install rofi and config as default
# INFO: Rofi is a simple text switcher and launcher
# DEFAULT: y

comment_mark="#bl-postinstall.sh"

#if [ $(apt-cache pkgnames | grep "^rofi$" | wc -l) -eq 0 ]; then
#	echo "ERROR: cant find rofi in repositories"
#	exit 1
#fi

# Install compiled package rofi with icons
base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"
dpkg -i "$base_dir/postinstall-files/rofi/"*.deb
apt-get install -f

# Copy theme
cp -v "$base_dir/postinstall-files/rofi/android_notification2.rasi" "/usr/share/rofi/themes/"

for d in /usr/share/bunsen/skel/.config/  /home/*/.config/; do
	# Copy rc.xml config with shortkeys for rofi
	cp -v "$base_dir/postinstall-files/rc.xml" "$d/openbox/"
	
	# Set as runas in menu:
	sed -zi 's/<command>[[:blank:]]*\n[[:blank:]]*gmrun[[:blank:]]*\n[[:blank:]]*<\/command>/<command>rofi -show drun -display-drun Search -theme android_notification2<\/command>/' "$d/openbox/menu.xml"

	# Config super key as runas
	sed -i '/xcape.*Super_L.*space/s/^/#/g' "$d/openbox/autostart"  
	echo 'xcape -e "Super_L=Control_L|Tab"  '"$comment_mark" | tee -a  "$d/openbox/autostart"

done
