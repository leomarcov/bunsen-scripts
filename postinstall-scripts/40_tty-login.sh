#!/bin/bash
# ACTION: Disable lightdm and config login using tty
# INFO: Login in text mode is cool and nerd. You can use tt1 login and physlock for enter your password when go back from suspend and lock screen. 
# DEFAULT: y

comment_mark="#bl-postinstall.sh"
base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

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
cp "$base_dir"/postinstall-files/physlock.service /etc/systemd/system/
systemctl enable physlock.service
	
# Config tty1 to autoexec startx
sed -i "/$comment_mark/Id" /etc/profile
echo '[ $(tty) = "/dev/tty1" ] && startx && exit   '"$comment_mark" >> /etc/profile

# Show neofetch info at login
which neofetch &>/dev/null || apt-get install neofetch
if which neofetch &>/dev/null; then
	# Copy script and config files:
	cp -v /etc/issue /etc/issue.old
	[ ! -d "/etc/systemd/system/getty@.service.d/" ] && mkdir -vp "/etc/systemd/system/getty@.service.d/"
	[ ! -d "/usr/share/neofetch/" ] && mkdir -vp "/usr/share/neofetch/"
	cp -v "$base_dir/neofetch-tty-login/config_tty" /usr/share/neofetch/
	cp -v "$base_dir/neofetch-tty-login/neofetch_issue.sh" /usr/bin/
	chmod -v a+x /usr/bin/neofetch_issue.sh
	
	# Config getty to run neofetch_issue.sh every time tty start:
	echo '[Service]
ExecStartPre=-/bin/bash -c "/usr/bin/neofetch_issue.sh"' | tee "/etc/systemd/system/getty@.service.d/override.conf"
fi
