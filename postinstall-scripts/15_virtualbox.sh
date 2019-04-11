#!/bin/bash
# ACTION: Install VirtualBox 6.0, add to repositories and insert to Openbox menu
# DEFAULT: y

vb_package="virtualbox-6.0"
main_distro="$(cat /etc/apt/sources.list | grep ^deb | awk '{print $3}' | head -1)"

# Install repositories
grep -R "download.virtualbox.org" /etc/apt/ &> /dev/null || echo "deb http://download.virtualbox.org/virtualbox/debian $main_distro contrib" > /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

# Install packages
apt-get update
	
if apt-get install -y linux-headers-$(uname -r) "$vb_package"; then
	# Add VirtualBox in OpenBox menu:
	for f in /usr/share/bunsen/skel/.config/openbox/menu.xml  /home/*/.config/openbox/menu.xml ; do
		! grep '<command>virtualbox<\/command>' "$f" &> /dev/null && sed -i '0,/<separator\/>/s//<item label="VirtualBox"><action name="Execute"><command>virtualbox<\/command><\/action><\/item> <separator\/>/' "$f"
	done
fi
