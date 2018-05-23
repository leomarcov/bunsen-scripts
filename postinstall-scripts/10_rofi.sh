#!/bin/bash
# ACTION: Install and config rofi launcher
# DESC: Install rofi launcher and set as default to all user theme and runas
# DEFAULT: y

apt-get install -y rofi
	
# Set default theme (android_notification) and set rofi as Run program default por skel and current users:	
for d in /usr/share/bunsen/skel/.config/  /home/*/.config/; do
	[ ! -d "$d/rofi/" ] && mkdir -p "$d/rofi/"
	echo '#include "/usr/share/rofi/themes/android_notification.theme"' > "$d/rofi/config"
	sed -i 's/gmrun/rofi -show run/' "$d/openbox/rc.xml"
done
