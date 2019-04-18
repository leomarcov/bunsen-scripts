#!/bin/bash
# ACTION: Install new Terminator themes
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

base_dir="$(dirname "$(readlink -f "$0")")"

for f in /usr/share/bunsen/skel/.config/terminator/config  /home/*/.config/terminator/config; do
	cp -v "$base_dir"/terminator.config "$f"
done
