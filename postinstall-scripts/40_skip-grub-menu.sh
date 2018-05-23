#!/bin/bash
# ACTION: Config GRUB for skip menu
# DESC: If you are using only one OS in the computer you con skip GRUB menu for faster boot.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for i in $(cat "$basedir/postinstall-files/grub_skip.conf"  | cut -f1 -d=);do
	sed -i "/\b$i=/Id" /etc/default/grub
done
cat "$basedir/postinstall-files/grub_skip.conf" >> /etc/default/grub
update-grub
