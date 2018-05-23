#!/bin/bash
# ACTION: Config useful aliases for all users (root inclusive)
# DEFAULT: y

comment_mark="#bl-postinstall.sh"

for d in /home/*  /usr/share/bunsen/skel/  /root; do
		sed -i "/$comment_mark/Id" "$d/.bash_aliases" 2> /dev/null
		cat "$current_dir/postinstall-files/.bash_aliases" >> "$d/.bash_aliases"
done
