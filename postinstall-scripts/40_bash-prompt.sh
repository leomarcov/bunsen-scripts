#!/bin/bash
# ACTION: Config new bash prompt (all users)
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"
comment_mark="#bl-postinstall.sh"

for d in /home/*  /etc/skel  /root; do
	sed -i "/$comment_mark/Id" "$d/.bashrc" 2> /dev/null
	cat "$base_dir"/postinstall-files/.bashrc >> "$d/.bashrc"
done
