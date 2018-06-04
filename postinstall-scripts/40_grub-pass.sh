#!/bin/bash
# ACTION: Protect GRUB with password for prevent users edit entries
# DEFAULT: y

comment_mark="#bl-postinstall.sh"

# Ask for password
read -p "Enter password: " pass
if [ ! "$pass" ]; then
	echo "Password can't be empty"
	exit 1
fi

# Config admin user and password
pbkdf2_pass="$(echo -e "$pass\n$pass"| grub-mkpasswd-pbkdf2  | grep "grub.pbkdf2.*" -o)"
echo 'set superusers="admin"    '"$comment_mark"'
password_pbkdf2 admin '"$pbkdf2_pass   $comment_mark" | tee -a /etc/grub.d/40_custom 

# Config others users for select entry
for f in /etc/grub.d/*; do 
	sed -i 's/\bmenuentry\b/menuentry --unrestricted /g' "$i" 
	sed -i '/echo[[:blank:]]*"[[:blank:]]*submenu/ s/submenu/submenu --unrestricted/g' $f
done

update-grub
