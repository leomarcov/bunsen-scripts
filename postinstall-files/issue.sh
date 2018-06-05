#!/bin/bash
clear > /etc/issue
echo -e "\e[90m\l\e[0m">> /etc/issue
neofetch --config /usr/share/neofetch/config_tty >> /etc/issue

# Pending updates
updates=$(wc -l /var/cache/update-notification 2>/dev/null | cut -f1 -d" ")
[ "$updates" -gt 0 ] &>/dev/null && sed -i "/Packages/ s/$/($updates pending updates)/" /etc/issue

# Local IP
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
[ ! "$ip" ] && ip="unassigned"
sed -i 's/Users/Local IP/' /etc/issue
sed -i "/Local IP/ s/:.*/: $ip/" /etc/issue

# Show users:
echo -en "\e[1mUsers\e[0m: " >> /etc/issue
for u in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do 
	# Underline if sudo user:
	grep -Po '^sudo.+:\K.*$' /etc/group | grep -w "$u" &>/dev/null && echo -en "\e[4m" >> /etc/issue	
	# Red if lock user:
	[ "$(passwd -S $u | cut -f2 -d" ")" = "L" ] && echo -en "\e[91m" >> /etc/issue

	echo -en "$u\e[0m  " >> /etc/issue
done
echo >> /etc/issue 
