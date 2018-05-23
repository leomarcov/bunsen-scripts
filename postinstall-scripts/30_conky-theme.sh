#!/bin/bash
# ACTION: Install default Conky theme for all users
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for f in  /usr/share/bunsen/skel/.conkyrc  /home/*/.conkyrc ; do
	cp -v "$basename"/postinstall-files/.conkyrc "$f"
done
