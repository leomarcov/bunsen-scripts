#!/bin/bash
########################################################################
#### CONFIG ##########################################################
########################################################################
vb_package="virtualbox-5.2"
ep_url="https://download.virtualbox.org/virtualbox/5.2.12/Oracle_VM_VirtualBox_Extension_Pack-5.2.12.vbox-extpack"   #https://www.virtualbox.org/wiki/Downloads
current_dir="$(dirname "$(readlink -f "$0")")"



[ "$(id)" -ne 0 ] && echo "Administrative prvileges needed" && exit 1
read -p "Are you config a laptop (Y/n)? " laptop
########################################################################
#### PACKAGES ##########################################################
########################################################################
apt-get update

read -p "Install some useful packages (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  apt-get install vim
  apt-get install vlc 
  apt-get install haveged                        # Avoid delay first login
  apt-get install ttf-mscorefonts-installer
  apt-get install fonts-freefont-ttf
fi

# rofi
read -p "Install rofi launcher (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  apt-get install rofi
  cat "$current_dir"/config/rofi.conf >> /usr/share/bunsen/skel/.Xresources
  ls -d /home/* | xargs -I {} cp /usr/share/bunsen/skel/.Xresources {}/
  xrdb -load /usr/share/bunsen/skel/.Xresources  # ?????????? other users
fi


# PlayOnLinux
read -p "Install PlayOnLinux (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  apt-get install winbind
  apt-get install playonlinux
fi

# VirtualBox
read -p "Install VirtualBox and add repositories (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  apt-get update
  apt-get install linux-headers-$(uname -r) "$vb_package"
  # VirtualBox Extension Pack
  read -p "Install Extension Pack (Y/n)? " q
  if [ "${q,,}" = "y" ]; then
    t=$(mktemp -d)
    wget -P "$t" "$ep_url"  
    vboxmanage extpack install --replace "$t"/*extpack
    rm -rf "$t"
  fi
fi

# Sublime Text 3
read -p "Install Sublime-Text 3 and add repositories (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  apt-get update
  apt-get install sublime-text
  update-alternatives --install /usr/bin/bl-text-editor bl-text-editor /usr/bin/subl 90
  update-alternatives --set bl-text-editor /usr/bin/subl
fi

# Google Chrome
read -p "Install Google Chrome and add repositories (Y/n)? " q
if [ "${q,,}" = "y" ]; then
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
read -p "Copy some cool scripts (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  chmod +x "$current_dir"/bin/*
  cp "$current_dir"/bin/* /usr/bin/
  update-notification.sh -I      # Install update-notification
fi

read -p "Copy some cool wallpapers (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  cp "$current_dir"/wallpapers/* /usr/share/images/bunsen/wallpapers
fi

read -p "Copy some cool icon packs (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  unzip "$current_dir"/files/icons.zip -d /usr/share/icons/
fi

read -p "Copy some cool fonts (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  unzip "$current_dir"/files/fonts.zip -d /usr/share/fonts/
fi

read -p "Copy some cool themes (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  unzip "$current_dir"/files/themes.zip -d /usr/share/themes/
fi

########################################################################
#### SYSTEM CONFIG #####################################################
########################################################################
## DISABLE DISPLAY MANAGER
read -p "Disable graphical display manager (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  systemctl set-default multi-user.target
fi

read -p "Enable CTRL+ALT+BACKSPACE for kill X (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  echo 'XKBOPTIONS="terminate:ctrl_alt_bksp"' >> /etc/default/keyboard
fi

### SERVICES
read -p "Disable some stupid services (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  systemctl disable NetworkManager-wait-online.service
  systemctl disable ModemManager.service
  systemctl disable pppd-dns.service
fi

# GRUB CONIFG
read -p "Config Grub for bypass (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  sed -i "/\bGRUB_DEFAULT=/Id" /etc/default/grub
  sed -i "/\bGRUB_TIMEOUT=/Id" /etc/default/grub
  sed -i "/\bGRUB_HIDDEN_TIMEOUT=/Id" /etc/default/grub
  sed -i "/\bGRUB_CMDLINE_LINUX_DEFAULT=/Id" /etc/default/grub
  sed -i "/\bGRUB_CMDLINE_LINUX/Id" /etc/default/grub
  sed -i "/\bGRUB_DISABLE_OS_PROBER=/Id" /etc/default/grub
  sed -i "/\bGRUB_GFXMODE=/Id" /etc/default/grub
  sed -i "/\bGRUB_GFXPAYLOAD_LINUX=/Id" /etc/default/grub
  sed -i "/\bGRUB_BACKGROUND=/Id" /etc/default/grub
  echo '
  GRUB_DEFAULT=0
  GRUB_TIMEOUT=0
  GRUB_HIDDEN_TIMEOUT=0
  GRUB_CMDLINE_LINUX_DEFAULT=""
  GRUB_CMDLINE_LINUX=""
  GRUB_DISABLE_OS_PROBER=true
  GRUB_GFXMODE=auto
  GRUB_GFXPAYLOAD_LINUX=keep
  GRUB_BACKGROUND=""' >> /etc/default/grub

  for i in $(cat "$current_dir"/config/grub.conf  | cut -f1 -d=);do
    sed -i "/\b$i=/Id" /etc/default/grub
  done
  cat "$current_dir"/config/grub.conf >> /etc/default/grub
  update-grub
fi



########################################################################
#### USER CONFIG #######################################################
########################################################################
# tint2 config
read -p "Add tin2 themes (Y/n)? " q
if [ "${q,,}" = "y" ]; then
  cp "$current_dir"/config/*.tint /usr/share/bunsen/skel/.config/tint2/
  ls -d /home/* | xargs -I {} cp "$current_dir"/config/*.tint {}.config/tint2/
fi

# aliases
read -p "Add some aliases (Y/n)? " q
if [ "${q,,}" = "y" ]; then
   cat "$current_dir"/config/aliases >> /usr/share/bunsen/skel/.bash_aliases
  ls -d /home/* | xargs -I {} cp /usr/share/bunsen/skel/.bash_aliases {}/
fi

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


