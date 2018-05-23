#!/bin/bash
# ACTION: Config system for show messages during boot
# DESC: In boot process the system can show a stupid logo or messages about the booting process.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for i in $(cat "$basedir/postinstall-files/grub_textboot.conf"  | cut -f1 -d=);do
	sed -i "/\b$i=/Id" /etc/default/grub
done
cat "$basedir/postinstall-files/grub_textboot.conf" >> /etc/default/grub
update-grub
