#!/bin/bash
# ACTION: Set default wallpaper for all users
# INFO: Aptenodytes Forsteri Wallpaper by Nixiepro is a clear and beautiful Bunsen wallpaper.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"
wp_default="bl-colorful-aptenodytes-forsteri-by-nixiepro.png"

cp -v "$basedir/postinstall-files/wallpapers/$wp_default" /usr/share/images/bunsen/wallpapers/

for f in  /usr/share/bunsen/skel/.config/nitrogen/bg-saved.cfg  /home/*/.config/nitrogen/bg-saved.cfg; do
	sed -i 's/^file *= *.*/file='$(echo "/usr/share/images/bunsen/wallpapers/$wp_default" | sed 's/\//\\\//g' )'/' "$f"
done
