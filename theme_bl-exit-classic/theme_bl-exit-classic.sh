#!/bin/bash
# ACTION: Config theme bl-exit with the classic theme

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

sed  -i "s/^theme *= *.*/theme = classic/" /etc/bl-exit/bl-exitrc	
sed -i "s/^rcfile *= *.*/rcfile = none/" /etc/bl-exit/bl-exitrc

for f in  /usr/share/bunsen/skel/.config/openbox/rc.xml  /home/*/.config/openbox/rc.xml ; do
    # Enable bl-exit window decoration
    sed -i '/<application name="bl-exit">/,/<\/application>/d' "$f"
done
