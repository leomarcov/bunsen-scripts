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
	echo -e 'Install configs and themes after BunsenLabs '"$bunsen_ver"' installation
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
	apt-get install -y vim vlc ttf-mscorefonts-installer fonts-freefont-ttf fonts-droid-fallback rar
	apt-get install -y haveged		# Avoid delay first login in Helium
fi

# Rofi laucher
if do_action "INSTALL AND CONFIG AS DEFAULT: rofi launcher"; then
	apt-get install -y rofi
	
	# Set default theme (android_notification) and set rofi as Run program default por skel and current users:	
	for d in /usr/share/bunsen/skel/.config/  /home/*/.config/; do
		[ ! -d "$d/rofi/" ] && mkdir -p "$d/rofi/"
		echo '#include "/usr/share/rofi/themes/android_notification.theme"' > "$d/rofi/config"
		sed -i 's/gmrun/rofi -show run/' "$d/openbox/rc.xml"
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
	if apt-get install sublime-text; then
		update-alternatives --install /usr/bin/bl-text-editor bl-text-editor /usr/bin/subl 90 && \
		update-alternatives --set bl-text-editor /usr/bin/subl
	fi
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
	
	if apt-get install -y linux-headers-$(uname -r) "$vb_package"; then
		# Add VirtualBox in OpenBox menu:
		sed -i '0,/<separator\/>/s//<item label="VirtualBox"><action name="Execute"><command>virtualbox<\/command><\/action><\/item> <separator\/>/'   /usr/share/bunsen/skel/.config/openbox/menu.xml
		ls /home/*/.config/openbox/menu.xml | xargs -I {} sed -i '0,/<separator\/>/s//<item label="VirtualBox"><action name="Execute"><command>virtualbox<\/command><\/action><\/item> <separator\/>/' {}
	fi
fi

# VirtualBox Extension Pack
if do_action "INSTALL: Extension Pack"; then
	t=$(mktemp -d)
	wget -P "$t" "$ep_url"  && \
	yes | vboxmanage extpack install --replace "$t"/*extpack 
	rm -rf "$t"
fi

#=== FILE ACTIONS ====================================================================
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
	chmod +x /usr/bin/brightness.sh
fi

# wallpapers
if do_action "INSTALL AND CONFIG AS DEFAULT: Aptenodytes Forsteri Wallpaper by Nixiepro"; then
	if [ ! -d /usr/share/images/bunsen/wallpapers/anothers/ ]; then
		mkdir -p /usr/share/images/bunsen/wallpapers/anothers/
		cp -v "$current_dir"/postinstall-files/wallpapers/* /usr/share/images/bunsen/wallpapers/anothers/
	fi
	
	for f in  /usr/share/bunsen/skel/.config/nitrogen/bg-saved.cfg  /home/*/.config/nitrogen/bg-saved.cfg; do
		sed -i 's/^file *= *.*/file='$(echo "/usr/share/images/bunsen/wallpapers/anothers/$wallpaper_default" | sed 's/\//\\\//g' )'/' "$f"
	done
fi

# Icons
if do_action "INSTALL AND CONFIG AS DEFAULT: Numix-Paper icon theme"; then
	apt-get install -y numix-icon-theme paper-icon-theme bunsen-paper-icon-theme
	icon_default="Numix-Paper"
	unzip  "$current_dir"/numix-paper-icon-theme/numix-paper-icon-theme.zip	-d /usr/share/icons/	
	
	for f in  /usr/share/bunsen/skel/.gtkrc-2.0  /home/*/.gtkrc-2.0 ; do
		sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'"$icon_default"'"/' "$f"		
	done
	for f in  /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini  /home/*/.config/gtk-3.0/settings.ini ; do
		sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name='"$icon_default"'/' "$f"
	done
fi

# Fonts
if do_action "INSTALL: some cool fonts"; then
	[ ! -d /usr/share/fonts/extra ] && mkdir /usr/share/fonts/extra/
	unzip "$current_dir"/postinstall-files/fonts.zip -d /usr/share/fonts/extra/
fi

# Openbox themes
if do_action "INSTALL AND SET AS DEFAULT: Openbox theme"; then
	unzip "$current_dir"/postinstall-files/openbox_themes.zip -d /usr/share/themes/
	for d in  /usr/share/bunsen/skel/.config/openbox/  /home/*/.config/openbox/ ; do
		cp -v "$current_dir/postinstall-files/rc.xml" "$d"
	done
fi

# GTK themes
if do_action "INSTALL AND CONFIG AS DEFAULT: Arc GTK theme"; then
	gtk_default="Arc"
	apt-get -y install arc-theme
	find /usr/share/themes/Arc -type f -exec sed -i 's/#5294e2/#b3bcc6/g' {} \;   # Change blue (#5294e2) acent color for grey
	
	for f in  /usr/share/bunsen/skel/.gtkrc-2.0  /home/*/.gtkrc-2.0 ; do
		sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"$gtk_default"'"/' "$f"		
	done
	for f in  /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini  /home/*/.config/gtk-3.0/settings.ini ; do
		sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name='"$gtk_default"'/' "$f"
	done		
fi

# Terminator theme
if do_action "INSTALL AND CONFIG AS DEFAULT: Terminator theme"; then
	for f in  /usr/share/bunsen/skel/.config/terminator/config  /home/*/.config/terminator/config; do
		cp -v "$current_dir"/postinstall-files/terminator.config "$f"
	done
fi

# conky
if do_action "INSTALL AND CONFIG AS DEFAULT: new conky default"; then
	for f in  /usr/share/bunsen/skel/.conkyrc  /home/*/.conkyrc ; do
		cp -v "$current_dir"/postinstall-files/.conkyrc "$f"
	done
fi

# tint2 config
if do_action "INSTALL AND CONFIG AS DEFAULT: tin2 theme"; then
	for d in /usr/share/bunsen/skel/.config/tint2/  /home/*/.config/tint2/; do
		[ ! -f "$d/tint2rc_bunsen" ] && cp -v "$d/tint2rc" "$d/tint2rc_bunsen"
		cp -v "$current_dir"/postinstall-files/*tint* "$d"
		[ "$laptop" ] && [ ! "$virtualmachine" ] &&  sed -i '/LAPTOP/s/^#//g' "$d/tint2rc"	# uncomment LAPTOP lines
	done
fi


#=== SYSTEM CONFIG ACTIONS ====================================================================
## Disable DM
if do_action "CONFIG: disable graphical display manager and install text locker"; then
	systemctl set-default multi-user.target
	apt-get -y remove lightdm

	# Install physlock
	apt-get install libpam0g-dev	
	t=$(mktemp -d)
	wget -P "$t" "https://github.com/muennich/physlock/archive/master.zip"  
	unzip "$t"/*.zip -d "$t"
	rm "$t"/*.zip
	make -C "$t"/*
	make -C "$t"/* install
	
	# Config physlock as default locker
	sed  -i 's/^LOCK_COMMAND *= *.*/LOCK_COMMAND=\(\/usr\/local\/bin\/physlock\)/' /usr/bin/bl-lock
	
	# Config physlock for start after suspend
	cp "$current_dir"/postinstall-files/physlock.service /etc/systemd/system/
	systemctl enable physlock.service
	
	# Config tty1 to autoexec startx
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
	cat "$current_dir"/postinstall-files/grub_textboot.conf >> /etc/default/grub
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
	for d in /home/*  /usr/share/bunsen/skel/  /root; do
		sed -i "/$comment_auto/Id" "$d/.bash_aliases" 2> /dev/null
		cat "$current_dir/postinstall-files/.bash_aliases" >> "$d/.bash_aliases"
	done
fi

# prompt
if do_action "CONFIG: new bash prompt"; then
	for d in /home/*  /etc/skel  /root; do
		sed -i "/$comment_auto/Id" "$d/.bashrc" 2> /dev/null
		cat "$current_dir"/postinstall-files/.bashrc >> "$d/.bashrc"
	done
fi

# default brightness
if [ "$laptop" ] && do_action "Set default brightness when start openbox (edit value in /usr/bin/brightness.sh)"; then
	for f in  /usr/share/bunsen/skel/.config/openbox/autostart  /home/*/.config/openbox/autostart; do
		sed -i "/brightness.sh -def/Id" "$d/.bashrc" 2> /dev/null
		echo "brightness.sh -def &" >> "$f"
	done
fi

# reboot
if [ ! "$list" ] && [ ! "$actions" ] && do_action "Reboot" ; then 
	reboot
fi

