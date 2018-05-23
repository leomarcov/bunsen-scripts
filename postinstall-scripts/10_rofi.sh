#!/bin/bash
# ACTION: Install and config rofi launcher
# DESC: Install rofi launcher and set as default to all user theme and runas
# DEFAULT: y

apt-get install -y rofi
	
for d in /usr/share/bunsen/skel/.config/  /home/*/.config/; do
	[ ! -d "$d/rofi/" ] && mkdir -p "$d/rofi/"
	# Set defaul theme: android:notification:
	echo '#include "/usr/share/rofi/themes/android_notification.theme"' > "$d/rofi/config"
	# Set has runas Super+F2:
	sed -i 's/<command>gmrun<\/command>/<command>rofi -show run<\/command>/' "$d/openbox/rc.xml"
	# Set as runas in menu:
	sed -zi 's/<command>[[:blank:]]*\n[[:blank:]]*gmrun[[:blank:]]*\n[[:blank:]]*<\/command>/<command>rofi -show run<\/command>/' "$d/openbox/menu.xml"
done
