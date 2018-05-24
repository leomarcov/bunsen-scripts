#!/bin/bash
# ACTION: Config useful aliases
# DEFAULT: y

comment_mark="#bl-postinstall.sh"
base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for d in /home/*  /usr/share/bunsen/skel/  /root; do
		sed -i "/$comment_mark/Id" "$d/.bash_aliases" 2> /dev/null
		cat "$base_dir/postinstall-files/.bash_aliases" >> "$d/.bash_aliases"
done
