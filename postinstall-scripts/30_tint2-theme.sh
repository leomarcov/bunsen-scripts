#!/bin/bash
# ACTION: Install tint2 bar theme for all users
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for d in /usr/share/bunsen/skel/.config/tint2/  /home/*/.config/tint2/; do
	[ ! -f "$d/tint2rc_bunsen" ] && cp -v "$d/tint2rc" "$d/tint2rc_bunsen"
	cp -v "$basedir"/postinstall-files/*tint* "$d"
	[ "$laptop" ] && [ ! "$virtualmachine" ] &&  sed -i '/LAPTOP/s/^#//g' "$d/tint2rc"	# uncomment LAPTOP lines
done
