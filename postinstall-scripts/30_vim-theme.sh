#!/bin/bash
# ACTION: Install vim config
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

for d in  /usr/share/bunsen/skel/  /home/*/ ; do
	cp -v "$base_dir"/postinstall-files/vimrc "$d/.vimrc"
done
