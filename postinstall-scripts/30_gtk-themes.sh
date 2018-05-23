#!/bin/bash
# ACTION: Install Arc GTK theme
# INFO: Arc GTK theme is a clear and cool GTK theme. 
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

gtk_default="Arc"
apt-get -y install arc-theme

# Change accent color blue (#5294e2) for grey:
find /usr/share/themes/Arc -type f -exec sed -i 's/#5294e2/#b3bcc6/g' {} \;   
	
for f in  /usr/share/bunsen/skel/.gtkrc-2.0  /home/*/.gtkrc-2.0 ; do
	sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"$gtk_default"'"/' "$f"		
done
for f in  /usr/share/bunsen/skel/.config/gtk-3.0/settings.ini  /home/*/.config/gtk-3.0/settings.ini ; do
	sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name='"$gtk_default"'/' "$f"
done	
