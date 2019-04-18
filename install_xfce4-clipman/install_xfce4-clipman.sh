#!/bin/bash
# ACTION: Replace clipit for xfce4-clipman (allow screenshot to clipboard)
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

find /var/cache/apt/pkgcache.bin -mtime 0 &>/dev/null ||  apt-get update  
apt-get -y install xfce4-clipman
apt-get remove clipit

for f in /usr/share/bunsen/skel/.config/openbox/autostart  /home/*/.config/openbox/autostart; do
    sed -i 's/clipit/xfce4-clipman/g' "$f"
done
