#!/bin/bash
########################################################################
#### SCRIPT CONFIG #####################################################
########################################################################
bunsen_ver="Helium"
vb_package="virtualbox-5.2"
ep_url="https://download.virtualbox.org/virtualbox/5.2.12/Oracle_VM_VirtualBox_Extension_Pack-5.2.12.vbox-extpack"   #https://www.virtualbox.org/wiki/Downloads
current_dir="$(dirname "$(readlink -f "$0")")"

[ "$(id -u)" -ne 0 ] && echo "Administrative privileges needed" && exit 1
read -p "Are you config a laptop (y/N)? " laptop


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


n=1

########################################################################
#### PACKAGES ##########################################################
########################################################################
apt-get update
	
q="Install some useful packages"
read -p "$(echo -e "\n\e[1m[$n] \e[4m$q$([ ! "$list" ] && echo " (Y/n)?")\e[0m ")" q
if [ ! "$list" ] && [ "${q,,}" != "n" ]; then
	apt-get install -y vim vls ttf-mscorefonts-installer fonts-freefont-ttf fonts-droid-fallback
	apt-get install -y haveged                        # Avoid delay first login
fi

q="Install rofi launcher"
read -p "$(echo -e "\n\e[1m[$n] \e[4m$q$([ ! "$list" ] && echo " (Y/n)?")\e[0m ")" q
if [ "${q,,}" != "n" ]; then
	apt-get install -y rofi
	cat "$current_dir"/config/rofi.conf >> /usr/share/bunsen/skel/.Xresources
	ls -d /home/* | xargs -I {} cp -v /usr/share/bunsen/skel/.Xresources {}/
	xrdb -load /usr/share/bunsen/skel/.Xresources  
fi


# PlayOnLinux
q="Install PlayOnLinux"
read -p "$(echo -e "\n\e[1m\e[4mInstall PlayOnLinux (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  apt-get install -y winbind
  apt-get install -y playonlinux
fi

# VirtualBox
q="Install VirtualBox and add repositories"
read -p "$(echo -e "\n\e[1m\e[4mInstall VirtualBox and add repositories (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  apt-get update
  apt-get install -y linux-headers-$(uname -r) "$vb_package"
fi

# VirtualBox Extension Pack
q="Install Extension Pack"
read -p "$(echo -e "\n\e[1m\e[4mInstall Extension Pack (Y/n)?\e[0m ")" q
  if [ "${q,,}" != "n" ]; then
    t=$(mktemp -d)
    wget -P "$t" "$ep_url"  
    vboxmanage extpack install --replace "$t"/*extpack
    rm -rf "$t"
  fi
fi

# Sublime Text 3
q="Install Sublime-Text 3 and add repositories"
read -p "$(echo -e "\n\e[1m\e[4mInstall Sublime-Text 3 and add repositories (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  apt-get update
  apt-get install sublime-text
  update-alternatives --install /usr/bin/bl-text-editor bl-text-editor /usr/bin/subl 90
  update-alternatives --set bl-text-editor /usr/bin/subl
fi

# Google Chrome
q="Install Google Chrome and add repositories"
read -p "$(echo -e "\n\e[1m\e[4mInstall Google Chrome and add repositories (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
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
q="Copy some cool scripts"
read -p "$(echo -e "\n\e[1m\e[4mCopy some cool scripts (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  chmod +x "$current_dir"/bin/*
  cp -v "$current_dir"/bin/* /usr/bin/
  update-notification.sh -I      # Install update-notification
fi

q="Copy some cool wallpapers"
read -p "$(echo -e "\n\e[1m\e[4mCopy some cool wallpapers (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  cp "$current_dir"/wallpapers/* /usr/share/images/bunsen/wallpapers
fi

q="Copy some cool icon packs"
read -p "$(echo -e "\n\e[1m\e[4mCopy some cool icon packs (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  zip -FF "$current_dir"/files/icons.zip --out "$current_dir"/files/icons-full.zip
  unzip "$current_dir"/files/icons-full.zip -d /usr/share/icons/
fi

q="Copy some cool fonts"
read -p "$(echo -e "\n\e[1m\e[4mCopy some cool fonts (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  unzip "$current_dir"/files/fonts.zip -d /usr/share/fonts/
fi

q="Copy some cool themes"
read -p "$(echo -e "\n\e[1m\e[4mCopy some cool themes (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  unzip "$current_dir"/files/themes.zip -d /usr/share/themes/
fi


########################################################################
#### SYSTEM CONFIG #####################################################
########################################################################
## DISABLE DISPLAY MANAGER
q="Disable graphical display manager"
read -p "$(echo -e "\n\e[1m\e[4mDisable graphical display manager (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  systemctl set-default multi-user.target
  sed -i "/#BL-POSTINSTALL/Id" /etc/profile
  echo '[ $(tty) = "/dev/tty1" ] && startx; exit   #BL-POSTINSTALL' >> /etc/profile
fi

q="Enable CTRL+ALT+BACKSPACE for kill X"
read -p "$(echo -e "\n\e[1m\e[4mEnable CTRL+ALT+BACKSPACE for kill X (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  sed -i "/#BL-POSTINSTALL/Id" /etc/default/keyboard
  echo 'XKBOPTIONS="terminate:ctrl_alt_bksp    #BL-POSTINSTALL"' >> /etc/default/keyboard
fi

### SERVICES
q="Disable some stupid services"
read -p "$(echo -e "\n\e[1m\e[4mDisable some stupid services (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  systemctl disable NetworkManager-wait-online.service
  systemctl disable ModemManager.service
  systemctl disable pppd-dns.service
fi

# GRUB CONIFG
q="Skip Grub menu and enter Bunsen directly"
read -p "$(echo -e "\n\e[1m\e[4mSkip Grub menu and enter Bunsen directly  (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  for i in $(cat "$current_dir"/config/grub_skip.conf  | cut -f1 -d=);do
    sed -i "/\b$i=/Id" /etc/default/grub
  done
  cat "$current_dir"/config/grub_skip.conf >> /etc/default/grub
  update-grub
fi

q="Show messages during boot"
read -p "$(echo -e "\n\e[1m\e[4mShow messages during boot  (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
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
q="Configure bl-exit classic theme"
read -p "$(echo -e "\n\e[1m\e[4mConfigure bl-exit classic theme (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  sed  -i "s/^theme *= *.*/theme = classic/" /etc/bl-exit/bl-exitrc	
  sed  -i "s/^rcfile *= *.*/rcfile = none/" /etc/bl-exit/bl-exitrc
fi

# tint2 config
q="Add tin2 themes"
read -p "$(echo -e "\n\e[1m\e[4mAdd tin2 themes (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  cp -v"$current_dir"/config/*.tint /usr/share/bunsen/skel/.config/tint2/
  ls -d /home/* | xargs -I {} cp -v "$current_dir"/config/*.tint {}.config/tint2/
fi

# aliases
q="Add some aliases"
read -p "$(echo -e "\n\e[1m\e[4mAdd some aliases (Y/n)?\e[0m ")" q
if [ "${q,,}" != "n" ]; then
  sed -i "/#BL-POSTINSTALL/Id" /usr/share/bunsen/skel/.bash_aliases
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


