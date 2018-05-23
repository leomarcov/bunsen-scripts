#!/bin/bash
# ACTION: Config new bash prompt (all users)
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"
comment_mark="#bl-postinstall.sh"

for d in /home/*  /etc/skel  /root; do
	sed -i "/$comment_mark/Id" "$d/.bashrc" 2> /dev/null
	cat "$basedir"/postinstall-files/.bashrc >> "$d/.bashrc"
done
