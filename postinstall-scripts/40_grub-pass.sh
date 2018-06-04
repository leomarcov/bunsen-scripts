#!/bin/bash
# ACTION: Protect GRUB with password for prevent users edit entries
# DEFAULT: y

read -p "Enter password: " pass
if [ ! "$pass" ]; then
	echo "Password can't be empty"
	exit 1
fi

pbkdf2_pass="$(echo -e "$pass\n$pass"| grub-mkpasswd-pbkdf2  | grep "grub.pbkdf2.*" -o)"

echo 'set superusers="admin"
password_pbkdf2 admin '"$pbkdf2_pass" | tee -a /etc/default/grub
