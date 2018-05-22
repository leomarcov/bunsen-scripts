#!/bin/bash
#=== SCRIPT CONFIGS ============================================================
bunsen_ver="Helium"
openbox_default="GoHomeV2-leo"
wallpaper_default="bl-colorful-aptenodytes-forsteri-by-nixiepro.png"
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


#=== CHECKS ===================================================================
[ ! "$list" ] && [ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1
if [ ! "$list"] && ! cat /etc/*release 2>/dev/null| grep "CODENAME" | grep -i "$bunsen_ver" &> /dev/null; then
	echo "Seems you are not running BunsenLabs $bunsen_ver"
	echo "Some packages may fail. Cross your fingers and press enter..."
	read
fi
[ -f /sys/module/battery/initstate ] || [ -d /proc/acpi/battery/BAT0 ] && laptop="true"
dmesg | grep -i hypervisor &>/dev/null && virtualmachine="true"
current_dir="$(dirname "$(readlink -f "$0")")"




#=== PACKAGE ACTIONS ====================================================================
# Mix packages
if do_action "INSTALL: some useful packages"; then
	apt-get install -y vim vlc ttf-mscorefonts-installer fonts-freefont-ttf fonts-droid-fallback
	apt-get install -y haveged		# Avoid delay first login in Helium
fi

# Rofi laucher
if do_action "INSTALL AND CONFIG AS DEFAULT: rofi launcher"; then
	apt-get install -y rofi
	# Set default theme (android_notification) and set rofi as Run program default por skel and current users:
	[ ! -d "/usr/share/bunsen/skel/.config/rofi/" ] && mkdir -p "/usr/share/bunsen/skel/.config/rofi/"
	echo '#include "/usr/share/rofi/themes/android_notification.theme"' > "/usr/share/bunsen/skel/.config/rofi/config"	
	sed -i 's/gmrun/rofi -show run/' /usr/share/bunsen/skel/.config/openbox/rc.xml
	for u in /home/*; do
		[ ! -d "$u/.config/rofi/" ] && mkdir -p "$u/.config/rofi/"
		echo '#include "/usr/share/rofi/themes/android_notification.theme"' > "$u/.config/rofi/config"
		sed -i 's/gmrun/rofi -show run/' "$u/.config/openbox/rc.xml"
	done
fi

# PlayOnLinux
if do_action "INSTALL: PlayOnLinux"; then
	apt-get install -y winbind
	apt-get install -y playonlinux
fi

# Sublime Text 3
if do_action "INSTALL AND ADD REPOSITORIES: Sublime-Text 3"; then
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	apt-get update
	apt-get install sublime-text
	update-alternatives --install /usr/bin/bl-text-editor bl-text-editor /usr/bin/subl 90
	update-alternatives --set bl-text-editor /usr/bin/subl
fi

# Google Chrome
if do_action "INSTALL AND ADD REPOSITORIES: Google Chrome"; then
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
	apt-get update
	apt-get install -y google-chrome-stable
fi

# VirtualBox
if do_action "INSTALL AND ADD REPOSITORIES: VirtualBox"; then
	echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
	apt-get update
	apt-get install -y linux-headers-$(uname -r) "$vb_package"
	
	# Add VirtualBox in OpenBox menu:
	sed -i '0,/<separator\/>/s//<item label="VirtualBox"><action name="Execute"><command>virtualbox<\/command><\/action><\/item> <separator\/>/'   /usr/share/bunsen/skel/.config/openbox/menu.xml
	ls /home/*/.config/openbox/menu.xml | xargs -I {} sed -i '0,/<separator\/>/s//<item label="VirtualBox"><action name="Execute"><command>virtualbox<\/command><\/action><\/item> <separator\/>/' {}
fi

# VirtualBox Extension Pack
if do_action "INSTALL: Extension Pack"; then
	t=$(mktemp -d)
	wget -P "$t" "$ep_url"  
	yes | vboxmanage extpack install --replace "$t"/*extpack 
	rm -rf "$t"
fi

#=== FILE ACTIONS ====================================================================
# Scripts
if do_action "INSTALL: some cool scripts"; then
	chmod +x "$current_dir"/bin/*
	cp -v "$current_dir"/bin/* /usr/bin/
fi

# update-notification
if do_action "INSTALL: script update-notification.sh for notify weekly for updates in tint bar"; then
	bash "$current_dir"/update-notification-tint/update-notification.sh -I 
fi

# autosnap
if do_action "INSTALL: script autosnap.sh for autosnap windows when center click in title"; then
	cp -v "$current_dir"/autosnap-openbox/autosnap.sh /usr/bin/
	chmod +x /usr/bin/autosnap.sh
fi

# ps_mem
if do_action "INSTALL: script ps_mem.py for show RAM usage por process"; then
	wget -P /usr/bin "https://raw.githubusercontent.com/pixelb/ps_mem/master/ps_mem.py"
	chmod +x /usr/bin/ps_mem.py
fi

# brightness
if do_action "INSTALL: script brightness.sh for control brightness"; then
	cp -v "$current_dir"/brightness-control/brightness.sh /usr/bin/
	chmod +x /usr/bin/ps_mem.py
fi

# wallpapers
if do_action "INSTALL AND CONFIG AS DEFAULT: Aptenodytes Forsteri Wallpaper by Nixiepro"; then
	if [ ! -d /usr/share/images/bunsen/wallpapers/anothers/ ]; then
		mkdir -p /usr/share/images/bunsen/wallpapers/anothers/
		cp -v "$current_dir"/postinstall-files/wallpapers/* /usr/share/images/bunsen/wallpapers/anothers/
	fi
	sed -i 's/^file *= *.*/file='$(echo "/usr/share/images/bunsen/wallpapers/anothers/$wallpaper_default" | sed 's/\//\\\//g' )'/' /usr/share/bunsen/skel/.config/nitrogen/bg-saved.cfg
	ls /home/*/.config/nitrogen/bg-saved.cfg | xargs -I {} sed -i 's/^file *= *.*/file='$(echo "/usr/share/images/bunsen/wallpapers/anothers/$wallpaper_default" | sed 's/\//\\\//g' )'/' {}
fi

# Icons
if do_action "INSTALL AND CONFIG AS DEFAULT: Numix-Paper icon theme"; then
	icon_default="Numix-Paper"
	unzip  "$current_dir"/numix-paper-icon-theme/numix-paper-icon-theme.zip	-d /usr/share/icons/	
	sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name='$icon_default'/' /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini
 	sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'$icon_default'"/' /usr/share/bunsen/skel/.gtkrc-2.0
 	ls /home/*/.config/gtk-3.0/settings.ini | xargs -I {} sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name='$icon_default'/' {}
	ls /home/*/.gtkrc-2.0 | xargs -I {} sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'$icon_default'"/' {}	
fi

# Fonts
if do_action "INSTALL: some cool fonts"; then
	[ ! -d /usr/share/fonts/extra ] && mkdir /usr/share/fonts/extra/
	unzip "$current_dir"/postinstall-files/fonts.zip -d /usr/share/fonts/extra/
fi

# Openbox themes
if do_action "INSTALL AND SET: Openbox themeS"; then
	unzip "$current_dir"/postinstall-files/openbox_themes.zip -d /usr/share/themes/
	cp -v "$current_dir"/postinstall-files/rc.xml /usr/share/bunsen/skel/.config/openbox/
	ls -d /home/*/.config/openbox/ | xargs -I {} cp -v "$current_dir"/postinstall-files/rc.xml {}	
fi

# GTK themes
if do_action "INSTALL AND CONFIG AS DEFAULT: Arc GTK theme"; then
	gtk_default="Arc"
	apt-get -y install arc-theme
	find /usr/share/themes/Arc -type f -exec sed -i 's/#5294e2/#b3bcc6/g' {} \;   # Change blue (#5294e2) acent color for grey
	sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name='"$gtk_default"'/' /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini
	sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"$gtk_default"'"/' /usr/share/bunsen/skel/.gtkrc-2.0
	ls /home/*/.config/gtk-3.0/settings.ini | xargs -I {} sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name='"$gtk_default"'/' {}
	ls /home/*/.gtkrc-2.0 | xargs -I {} sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"$gtk_default"'"/' {}		
fi

# Terminator theme
if do_action "INSTALL AND CONFIG AS DEFAULT: Terminator theme"; then
	cp -v "$current_dir"/postinstall-files/terminator.config  /usr/share/bunsen/skel/.config/terminator/config
	ls /home/*/.config/terminator/config | xargs -I {} cp -v "$current_dir"/postinstall-files/terminator.config {}
fi

# conky
if do_action "INSTALL AND CONFIG AS DEFAULT: new conky default"; then
	cp -v "$current_dir"/postinstall-files/conkyrc  /usr/share/bunsen/skel/.conkyrc
	ls /home/*/.conkyrc | xargs -I {} cp -v "$current_dir"/postinstall-files/.conkyrc {}
fi

# tint2 config
if do_action "INSTALL AND CONFIG AS DEFAULT: tin2 theme"; then
	[ ! -f /usr/share/bunsen/skel/.config/tint2/tint2rc_bunsen ] && cp -v /usr/share/bunsen/skel/.config/tint2/tint2rc /usr/share/bunsen/skel/.config/tint2/tint2rc_bunsen
	cp -v "$current_dir"/postinstall-files/*tint* /usr/share/bunsen/skel/.config/tint2/
	if [ "$laptop" ] && [ ! "$virtualmachine" ]; then
		sed -i '/LAPTOP/s/^#//g' /usr/share/bunsen/skel/.config/tint2/tint2rc	# uncomment LAPTOP lines
	fi
	for u in /home/*; do
		[ ! -f "$u/.config/tint2/tint2rc_bunsen" ] && cp -v "$u/.config/tint2/tint2rc" "$u/.config/tint2/tint2rc_bunsen"
		cp -v "$current_dir"/postinstall-files/*tint* "$u/.config/tint2/"
	done
fi


#=== SYSTEM CONFIG ACTIONS ====================================================================
## Disable DM
if do_action "CONFIG: disable graphical display manager"; then
	systemctl set-default multi-user.target
	sed -i "/#$comment_auto/Id" /etc/profile
	echo '[ $(tty) = "/dev/tty1" ] && startx && exit   '"$comment_auto" >> /etc/profile
fi

# Kill X
if do_action "CONFIG: enable CTRL+ALT+BACKSPACE for kill X server"; then
	sed -i "/XKBOPTIONS/Id" /etc/default/keyboard
	echo 'XKBOPTIONS="terminate:ctrl_alt_bksp"'>> /etc/default/keyboard
fi

# Disable services
if do_action "CONFIG: disable some stupid services"; then
	systemctl disable NetworkManager-wait-online.service
	systemctl disable ModemManager.service
	systemctl disable pppd-dns.service
fi

# Skip Grub menu
if do_action "CONFIG: skip GRUB menu and enter Bunsen directly"; then
	for i in $(cat "$current_dir"/postinstall-files/grub_skip.conf  | cut -f1 -d=);do
		sed -i "/\b$i=/Id" /etc/default/grub
	done
	cat "$current_dir"/postinstall-files/grub_skip.conf >> /etc/default/grub
	update-grub
fi

# Show boot msg
if do_action "CONIFG: show messages during boot"; then
	for i in $(cat "$current_dir"/postinstall-files/grub_textboot.conf  | cut -f1 -d=);do
		sed -i "/\b$i=/Id" /etc/default/grub
	done
	cat "$current_dir"/postinstall-files/grub_text.conf >> /etc/default/grub
	update-grub
fi


#=== USER CONFIG ====================================================================
# bl-exit theme
if do_action "CONFIG: bl-exit classic theme"; then
	sed  -i "s/^theme *= *.*/theme = classic/" /etc/bl-exit/bl-exitrc	
	sed  -i "s/^rcfile *= *.*/rcfile = none/" /etc/bl-exit/bl-exitrc
fi


# aliases
if do_action "CONFIG: some useful aliases"; then
	sed -i "/$comment_auto/Id" /usr/share/bunsen/skel/.bash_aliases
	cat "$current_dir"/postinstall-files/aliases >> /usr/share/bunsen/skel/.bash_aliases
	ls -d /home/*/ | xargs -I {} cp -v /usr/share/bunsen/skel/.bash_aliases {}
fi

# prompt
if do_action "CONFIG: new bash prompt"; then
	cat "$current_dir"/postinstall-files/bashrc >> /etc/skel/.bashrc
	for f in $(ls /home/*/.bashrc); do
		cat "$current_dir"/postinstall-files/bashrc >> "$f"
	done
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

