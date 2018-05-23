#!/bin/bash
# ACTION: Install Terminator themes
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for f in  /usr/share/bunsen/skel/.config/terminator/config  /home/*/.config/terminator/config; do
	cp -v "$basedir"/postinstall-files/terminator.config "$f"
done
