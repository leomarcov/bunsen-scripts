#!/bin/bash
# ACTION: Copy wallpapers pack and set Aptenodytes wallpaper as default
# INFO: Aptenodytes Forsteri Wallpaper by Nixiepro is a clear and beautiful Bunsen wallpaper.
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"
wp_default="bl-colorful-aptenodytes-forsteri-by-nixiepro.png"

cp -v "$base_dir/postinstall-files/wallpapers/"* /usr/share/images/bunsen/wallpapers/

for f in  /usr/share/bunsen/skel/.config/nitrogen/bg-saved.cfg  /home/*/.config/nitrogen/bg-saved.cfg; do
	sed -i 's/^file *= *.*/file='$(echo "/usr/share/images/bunsen/wallpapers/$wp_default" | sed 's/\//\\\//g' )'/' "$f"
done
