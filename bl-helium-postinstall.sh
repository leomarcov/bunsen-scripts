#!/bin/bash
#=== SCRIPT CONFIGS ============================================================
bunsen_ver="Helium"
icontheme_default="Numix"
comment_auto="#BL-POSTINSTALL"
vb_package="virtualbox-5.2"
ep_url="https://download.virtualbox.org/virtualbox/5.2.12/Oracle_VM_VirtualBox_Extension_Pack-5.2.12.vbox-extpack"   #https://www.virtualbox.org/wiki/Downloads


#=== FUNCTION ==================================================================
# NAME: help
# DESCRIPTION: Show command help
#===============================================================================
function help() {
	echo -e 'Apply config actions after Bunsen '"$bunsen_ver"' installation
Usage: '$(basename $0)' [-h] [-l] [-a <actions>]
   \e[1m-l\e[0m\t\tOnly list actions 
   \e[1m-a <actions>\e[0m\tOnly do selected actions (e.g: -a 5,6,10-15)
   \e[1m-y\e[0m\t\tAuto-answer yes to all actions
   \e[1m-h\e[0m\t\tShow this help'
	exit 0
}


#=== FUNCTION ==================================================================
# NAME: do_action
# DESCRIPTION: Show question to do an action and determine if do or not
# EXIT CODE: 0 if should be do de action, 1 in other case
#===============================================================================
n=0
function do_action() {
	n=$((n+1))
	[ "$actions" ] && { echo "$actions" | grep -w "$n" &> /dev/null || return 1; } 
	q="$1"
	[ "$list" ] && echo -e "[$n] $q" && return 1

	echo -en "\n\e[1m[$n] \e[4m$q\e[0m (Y/n)? "
	[ "$yes" ] && q="y" || read q 
	[ "${q,,}" != "n" ] && return 0
	return 1
}


#=== CHECKS ===================================================================
[ ! "$list" ] && [ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1
if [ ! "$list"] && ! cat /etc/*release 2>/dev/null| grep "CODENAME" | grep -i "$bunsen_ver" &> /dev/null; then
	echo "Seems you are not running BunsenLabs $bunsen_ver"
	echo "Some actions may fail. Cross your fingers and press enter..."
	read
fi
[ -f /sys/module/battery/initstate ] || [ -d /proc/acpi/battery/BAT0 ] && laptop="true"
dmesg | grep -i hypervisor &>/dev/null && virtualmachine="true"
current_dir="$(dirname "$(readlink -f "$0")")"

#=== PARAMS ====================================================================
while getopts ":hla:y" o; do
	case "$o" in
	h)	help 		;;
	l)	list="true"	;;
	y)	yes="true"	;;
	a)	for a in $(echo "$OPTARG" | tr "," " "); do
			# Is a range
			echo "$a" | grep -E "[0-9]"*-"[0-9]" &> /dev/null && actions="$actions $(eval echo {$(echo $a|sed "s/-/../")})"
			# Is a number 
			[ "$a" -eq 0 ] &>/dev/null; [ $? -le 1 ] && actions="$actions $a"
		done			
		;;
	esac
done




#=== PACKAGE ACTIONS ====================================================================
# Mix packages
if do_action "Install some useful packages"; then
	apt-get install -y vim vlc ttf-mscorefonts-installer fonts-freefont-ttf fonts-droid-fallback
	apt-get install -y haveged		# Avoid delay first login in Helium
fi

# Rofi laucher
if do_action "Install rofi launcher"; then
	apt-get install -y rofi
	# Set default theme (android_notification) and set rofi as Run program default por skel and current users:
	[ ! -d "/usr/share/bunsen/skel/.config/rofi/" ] && mkdir -p "/usr/share/bunsen/skel/.config/rofi/"
	echo '#include "/usr/share/rofi/themes/android_notification.theme"' > "/usr/share/bunsen/skel/.config/rofi/config"	
	sed -i '/^[[:blank:]]*gmrun[[:blank:]]*$/s/gmrun/rofi -show run/' /usr/share/bunsen/skel/.config/openbox/menu.xml
	for u in /home/*; do
		[ ! -d "$u/.config/rofi/" ] && mkdir -p "$u/.config/rofi/"
		echo '#include "/usr/share/rofi/themes/android_notification.theme"' > "$u/.config/rofi/config"
		sed -i '/^[[:blank:]]*gmrun[[:blank:]]*$/s/gmrun/rofi -show run/' "$u/.config/openbox/menu.xml"
	done
fi

# PlayOnLinux
if do_action "Install PlayOnLinux"; then
	apt-get install -y winbind
	apt-get install -y playonlinux
fi

# VirtualBox
if do_action "Install VirtualBox and add repositories"; then
	echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
	apt-get update
	apt-get install -y linux-headers-$(uname -r) "$vb_package"
	
	# Add VirtualBox in OpenBox menu:
	#echo '<item label="VirtualBox"><action name="Execute"><command>virtualbox</command></action></item>'
fi

# VirtualBox Extension Pack
if do_action "Install Extension Pack"; then
	t=$(mktemp -d)
	wget -P "$t" "$ep_url"  X
	yes | vboxmanage extpack install --replace "$t"/*extpack 
	rm -rf "$t"
fi

# Sublime Text 3
if do_action "Install Sublime-Text 3 and add repositories"; then
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	apt-get update
	apt-get install sublime-text
	update-alternatives --install /usr/bin/bl-text-editor bl-text-editor /usr/bin/subl 90
	update-alternatives --set bl-text-editor /usr/bin/subl
fi

# Google Chrome
if do_action "Install Google Chrome and add repositories"; then
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
	apt-get update
	apt-get install -y google-chrome-stable
fi

#=== FILE ACTIONS ====================================================================
# Scripts
if do_action "Copy some cool scripts"; then
	chmod +x "$current_dir"/bin/*
	cp -v "$current_dir"/bin/* /usr/bin/
fi

# update-notification
if do_action "Install script for notify weekly for updates"; then
	update-notification.sh -I  &>/dev/null    # Install update-notification
fi

# wallpapers
if do_action "Copy some cool wallpapers"; then
	if [ ! -d /usr/share/images/bunsen/wallpapers/anothers/ ]; then
		mkdir /usr/share/images/bunsen/wallpapers/anothers/
		cp -v "$current_dir"/wallpapers/* /usr/share/images/bunsen/wallpapers/anothers/
	fi
fi

# Icons
if do_action "Copy some cool icon packs"; then
	zip -FF "$current_dir"/files/icons.zip --out "$current_dir"/files/icons-full.zip
	unzip "$current_dir"/files/icons-full.zip -d /usr/share/icons/
	
	sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name='"$icontheme_default"'/' /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini
	sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'"$icontheme_default"'"/' /usr/share/bunsen/skel/.gtkrc-2.0
	ls /home/*/.config/gtk-3.0/settings.ini | xargs -I {} sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name='"$icontheme_default"'/' {}
	ls /home/*/.gtkrc-2.0 | xargs -I {} sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name='"$icontheme_default"'/' {}	
fi

# Fonts
if do_action "Copy some cool fonts"; then
	[ ! -d /usr/share/fonts/extra ] && mkdir /usr/share/fonts/extra/
	unzip "$current_dir"/files/fonts.zip -d /usr/share/fonts/extra/
fi

# Themes
if do_action "Copy some cool themes"; then
	unzip "$current_dir"/files/themes.zip -d /usr/share/themes/
fi


#=== SYSTEM CONFIG ACTIONS ====================================================================
## Disable DM
if do_action "Disable graphical display manager"; then
	systemctl set-default multi-user.target
	sed -i "/#$comment_auto/Id" /etc/profile
	echo '[ $(tty) = "/dev/tty1" ] && startx && exit   '"$comment_auto" >> /etc/profile
fi

# Kill X
if do_action "Enable CTRL+ALT+BACKSPACE for kill X"; then
	sed -i "/XKBOPTIONS/Id" /etc/default/keyboard
	echo 'XKBOPTIONS="terminate:ctrl_alt_bksp"'>> /etc/default/keyboard
fi

# Disable services
if do_action "Disable some stupid services"; then
	systemctl disable NetworkManager-wait-online.service
	systemctl disable ModemManager.service
	systemctl disable pppd-dns.service
fi

# Skip Grub menu
if do_action "Skip Grub menu and enter Bunsen directly"; then
	for i in $(cat "$current_dir"/config/grub_skip.conf  | cut -f1 -d=);do
		sed -i "/\b$i=/Id" /etc/default/grub
	done
	cat "$current_dir"/config/grub_skip.conf >> /etc/default/grub
	update-grub
fi

# Show boot msg
if do_action "Show messages during boot"; then
	for i in $(cat "$current_dir"/config/grub_text.conf  | cut -f1 -d=);do
		sed -i "/\b$i=/Id" /etc/default/grub
	done
	cat "$current_dir"/config/grub_text.conf >> /etc/default/grub
	update-grub
fi


#=== USER ACTIONS ====================================================================
# bl-exit theme
if do_action "Configure bl-exit classic theme"; then
	sed  -i "s/^theme *= *.*/theme = classic/" /etc/bl-exit/bl-exitrc	
	sed  -i "s/^rcfile *= *.*/rcfile = none/" /etc/bl-exit/bl-exitrc
fi

# tint2 config
if do_action "Add tin2 themes"; then
	[ ! -f /usr/share/bunsen/skel/.config/tint2/tint2rc_bunsen ] && cp -v /usr/share/bunsen/skel/.config/tint2/tint2rc /usr/share/bunsen/skel/.config/tint2/tint2rc_bunsen
	cp -v "$current_dir"/config/tint2rc_leo /usr/share/bunsen/skel/.config/tint2/tint2rc
	if [ "$laptop" ] && [ ! "$virtualmachine" ]; then
		sed -i '/LAPTOP/s/^#//g' /usr/share/bunsen/skel/.config/tint2/tint2rc	# uncomment LAPTOP lines
	fi
	for u in /home/*; do
		[ ! -f "$u/.config/tint2/tint2rc_bunsen" ] && cp -v "$u/.config/tint2/tint2rc" "$u/.config/tint2/tint2rc_bunsen"
		cp -v /usr/share/bunsen/skel/.config/tint2/tint2rc "$u/.config/tint2/tint2rc"
	done
fi

# aliases
if do_action "Add some aliases"; then
	sed -i "/$comment_auto/Id" /usr/share/bunsen/skel/.bash_aliases
	cat "$current_dir"/config/aliases >> /usr/share/bunsen/skel/.bash_aliases
	ls -d /home/*/ | xargs -I {} cp -v /usr/share/bunsen/skel/.bash_aliases {}
fi

# ob-rc
if do_action "Customize openbox shortcuts and mouse bindings"; then
	cp -v "$current_dir"/config/rc.xml /usr/share/bunsen/skel/.config/openbox/
	ls -d /home/*/.config/openbox/ | xargs -I {} cp -v "$current_dir"/config/rc.xml {}
fi

# default brightness
if [ "$laptop" ] && do_action "Set default brightness when start openbox (edit value in /usr/bin/brightness.sh)"; then
	echo "brightness.sh -def &" >> /usr/share/bunsen/skel/.config/openbox/autostart
	for f in /home/*/.config/openbox/autostart; do
		echo "brightness.sh -def &" >> "$f"
	done
fi

# reboot
if [ ! "$list" ] && [ ! "$actions" ] && do_action "Reboot" ; then 
	reboot
fi

