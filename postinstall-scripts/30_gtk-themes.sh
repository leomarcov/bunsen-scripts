#!/bin/bash
# ACTION: Install pack of fonts
# DESC: Pack of common fonts: Droid Sans, Open Sans, Roboto, Microsoft fonts, Oswald, Overpass, Profont, and others.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

gtk_default="Arc"
apt-get -y install arc-theme
find /usr/share/themes/Arc -type f -exec sed -i 's/#5294e2/#b3bcc6/g' {} \;   # Change blue (#5294e2) acent color for grey
	
for f in  /usr/share/bunsen/skel/.gtkrc-2.0  /home/*/.gtkrc-2.0 ; do
	sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"$gtk_default"'"/' "$f"		
done
for f in  /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini  /home/*/.config/gtk-3.0/settings.ini ; do
	sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name='"$gtk_default"'/' "$f"
done	
