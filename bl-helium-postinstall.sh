#!/bin/bash
########################################################################
#### SCRIPT CONFIG #####################################################
######################################################################## 
bunsen_ver="Helium"
vb_package="virtualbox-5.2"
ep_url="https://download.virtualbox.org/virtualbox/5.2.12/Oracle_VM_VirtualBox_Extension_Pack-5.2.12.vbox-extpack"   #https://www.virtualbox.org/wiki/Downloads
current_dir="$(dirname "$(readlink -f "$0")")"
comment_auto="#BL-POSTINSTALL"


#=== FUNCTION ==================================================================
# NAME: help
# DESCRIPTION: Show command help
#===============================================================================
function help() {
	echo -e 'Apply config actions after Bunsen '"$bunsen_ver"'installation
Usage: '$(basename $0)' [-h] [-l] [-a <actions>]
   \e[1m-h\e[0m\tShow command help
   \e[1m-l\e[0m\tOnly list actions 
   \e[1m-a <actions>\e[0m\tOnly apply selected actions (e.g: 5,6,10-15)'
	exit 0
}


#=== FUNCTION ==================================================================
# NAME: do_action
# DESCRIPTION: Show question for do an action and determine if do or not
# RETURN: 0 if should be do de action, 1 in other case
#===============================================================================
n=0
function do_action() {
	n=$((n+1))
	[ "$actions" ] && { echo "$actions" | grep -w "$n" &> /dev/null || return 1; } 
	q="$1"
	[ "$list" ] && echo -e "[$n] $q" && return 1

	read -p "$(echo -e "\n\e[1m[$n] \e[4m$q\e[0m (Y/n)? ")" q
	[ "${q,,}" != "n" ] && return 0
	return 1
}



[ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1
[ -f /sys/module/battery/initstate ] || [ -d /proc/acpi/battery/BAT0 ] && laptop="true"


while getopts ":hla:" o; do
	case "$o" in
	h)	help ;;
	l)	list="true" ;;
	a)	for a in $(echo "$OPTARG" | tr "," " "); do
			# Is a range
			echo "$a" | grep -E "[0-9]"*-"[0-9]" &> /dev/null && actions="$actions $(eval echo {$(echo $a|sed "s/-/../")})"
			# Is a number 
			[ "$a" -eq 0 ] &>/dev/null; [ $? -le 1 ] && actions="$actions $a"
		done			
		;;
	esac
done




########################################################################
#### PACKAGES ##########################################################
########################################################################
# Mix packages
if do_action "Install some useful packages"; then
	apt-get install -y vim vls ttf-mscorefonts-installer fonts-freefont-ttf fonts-droid-fallback
	apt-get install -y haveged		# Avoid delay first login
fi

# Rofi laucher
if do_action "Install rofi launcher"; then
	apt-get install -y rofi
	cat "$current_dir"/config/rofi.conf >> /usr/share/bunsen/skel/.Xresources
	ls -d /home/* | xargs -I {} cp -v /usr/share/bunsen/skel/.Xresources {}/
	xrdb -load /usr/share/bunsen/skel/.Xresources  
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
fi

# VirtualBox Extension Pack
if do_action "Install Extension Pack"; then
	t=$(mktemp -d)
	wget -P "$t" "$ep_url"  
	vboxmanage extpack install --replace "$t"/*extpack
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
	apt-get install google-chrome-stable
	update-alternatives --set x-www-browser /usr/bin/google-chrome-stable
	update-alternatives --set gnome-www-browser /usr/bin/google-chrome-stable
fi


########################################################################
#### FILES #############################################################
########################################################################
# Scripts
if do_action "Copy some cool scripts"; then
	chmod +x "$current_dir"/bin/*
	cp -v "$current_dir"/bin/* /usr/bin/
	update-notification.sh -I      # Install update-notification
fi

# Wallpapers
if do_action "Copy some cool wallpapers"; then
	cp "$current_dir"/wallpapers/* /usr/share/images/bunsen/wallpapers
fi

# Icons
if do_action "Copy some cool icon packs"; then
	zip -FF "$current_dir"/files/icons.zip --out "$current_dir"/files/icons-full.zip
	unzip "$current_dir"/files/icons-full.zip -d /usr/share/icons/
fi

# Fonts
if do_action "Copy some cool fonts"; then
	unzip "$current_dir"/files/fonts.zip -d /usr/share/fonts/
fi

# Themes
if do_action "Copy some cool themes"; then
	unzip "$current_dir"/files/themes.zip -d /usr/share/themes/
fi


########################################################################
#### SYSTEM CONFIG #####################################################
########################################################################
## Disable DM
if do_action "Disable graphical display manager"; then
	systemctl set-default multi-user.target
	sed -i "/#$comment_auto/Id" /etc/profile
	echo "[ $(tty) = \"/dev/tty1\" ] && startx; exit   $comment_auto" >> /etc/profile
fi

# Kill X
if do_action "Enable CTRL+ALT+BACKSPACE for kill X"; then
	sed -i "/$comment_auto/Id" /etc/default/keyboard
	echo "XKBOPTIONS=\"terminate:ctrl_alt_bksp    $comment_auto\"" >> /etc/default/keyboard
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


########################################################################
#### USER CONFIG #######################################################
########################################################################
# bl-exit theme
if do_action "Configure bl-exit classic theme"; then
	sed  -i "s/^theme *= *.*/theme = classic/" /etc/bl-exit/bl-exitrc	
	sed  -i "s/^rcfile *= *.*/rcfile = none/" /etc/bl-exit/bl-exitrc
fi

# tint2 config
if do_action "Add tin2 themes"; then
	cp -v"$current_dir"/config/*.tint /usr/share/bunsen/skel/.config/tint2/
	ls -d /home/* | xargs -I {} cp -v "$current_dir"/config/*.tint {}.config/tint2/
fi

# aliases
if do_action "Add some aliases"; then
	sed -i "/$comment_auto/Id" /usr/share/bunsen/skel/.bash_aliases
	cat "$current_dir"/config/aliases >> /usr/share/bunsen/skel/.bash_aliases
	ls -d /home/* | xargs -I {} cp -v /usr/share/bunsen/skel/.bash_aliases {}/
fi


exit 
# Config shortcut in Openbox:
vi $HOME/.config/openbox/rc.xml
  <keyboard>
    ...
    <keybind key="C-Tab">
      <action name="Execute">
        <command>rofi -show drun</command>
      </action> 
    </keybind>
    <keybind key="A-Tab">
      <action name="Execute">
        <command>rofi -show window</command>
      </action> 
    </keybind>    
    ...

# OPENBOX AUTOSTART
vi $HOME/.config/openbox/autostart
brightness.sh -def &           # Set default brightness
xmodmap $HOME/.Xmodmap &
xbindkeys &
syndaemon -i 1 -d &           # Disable touchpad when using keyboard

