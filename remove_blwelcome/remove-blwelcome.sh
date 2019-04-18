#!/bin/bash
# ACTION: Remove bunsen-welcome autostart script 
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

apt-get -y remove bunsen-welcome

for f in /usr/share/bunsen/skel/.config/openbox/autostart  /home/*/.config/openbox/autostart; do
    sed -i "/bl-welcome/ s/^#*/#/" "$f"
done
