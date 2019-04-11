#!/bin/bash
# ACTION: Install new default Conky theme
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for f in  /usr/share/bunsen/skel/.conkyrc  /home/*/.conkyrc ; do
	cp -v "$base_dir"/postinstall-files/.conkyrc "$f"
done

if mount | grep -q "on /home[[:blank:]]"; then
for f in  /usr/share/bunsen/skel/.conkyrc  /home/*/.conkyrc; do
	sed -i '/Home usage/s/^#//g' "$f"
done
fi
