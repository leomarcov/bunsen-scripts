#!/bin/bash
# ACTION: Disable lightdm and config text display manager
# DESC: Boot and enter your password in text mode is cool. You can use tt1 login and physlock for enter your password when go back  from suspend and lock screen. 
# DEFAULT: y

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
