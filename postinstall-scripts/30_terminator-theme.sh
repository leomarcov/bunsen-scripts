#!/bin/bash
# ACTION: Install Terminator themes
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for f in  /usr/share/bunsen/skel/.config/terminator/config  /home/*/.config/terminator/config; do
	cp -v "$base_dir"/postinstall-files/terminator.config "$f"
done
