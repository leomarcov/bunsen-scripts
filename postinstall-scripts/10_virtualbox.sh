#!/bin/bash
# ACTION: Install VirtualBox
# DESC: Install Virtualbox 5.2, config official repositories and add VirtualBox to Openbox menu
# DEFAULT: y

vb_package="virtualbox-5.2"

echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
apt-get update
	
if apt-get install -y linux-headers-$(uname -r) "$vb_package"; then
	# Add VirtualBox in OpenBox menu:
	for f in /usr/share/bunsen/skel/.config/openbox/menu.xml  /home/*/.config/openbox/menu.xml ; do
		! grep '<command>virtualbox<\/command>' "$f" &> /dev/null && sed -i '0,/<separator\/>/s//<item label="VirtualBox"><action name="Execute"><command>virtualbox<\/command><\/action><\/item> <separator\/>/' "$f"
	done
fi
